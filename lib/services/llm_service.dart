import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/topic_model.dart';
import '../models/article_model.dart';
import '../data/prompts.dart';

class LlmService {
  late final Dio _dio;
  late final String _apiKey;

  LlmService() {
    _apiKey = dotenv.env['GROK_API_KEY_2'] ?? '';
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.groq.com/openai/v1',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 300),
    ));
  }

  Future<String> _generateResponse(String prompt) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.6,
        },
      );
      return response.data['choices'][0]['message']['content'] as String;
    } on DioException catch (e) {
      throw Exception('Grok API Error: ${e.response?.data ?? e.message}');
    }
  }

  /// Strips Markdown code fences and parses JSON
  dynamic _parseJson(String raw) {
    String cleaned = raw.trim();
    // Remove <think>...</think> completely (just in case)
    cleaned = cleaned.replaceAll(RegExp(r'<think>.*?</think>', dotAll: true), '');
    cleaned = cleaned.trim();
    
    // Find the first { or [ to ignore any conversational padding
    final startJson = cleaned.indexOf(RegExp(r'[\{\[]'));
    if (startJson != -1) {
      cleaned = cleaned.substring(startJson);
    }
    
    final endJson = cleaned.lastIndexOf(RegExp(r'[\}\]]'));
    if (endJson != -1) {
      cleaned = cleaned.substring(0, endJson + 1);
    }

    // Remove ```json ... ``` or ``` ... ```
    cleaned = cleaned.replaceAll(RegExp(r'^```json\s*', multiLine: true), '');
    cleaned = cleaned.replaceAll(RegExp(r'^```\s*', multiLine: true), '');
    cleaned = cleaned.replaceAll(RegExp(r'```$', multiLine: true), '');
    return jsonDecode(cleaned.trim());
  }

  /// Helper to safely cast dynamic values to strings, handling lists gracefully
  String _safeString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is List) return value.map((e) => e.toString()).join('\n');
    return value.toString();
  }

  /// Step 2: Evaluate and score raw topics
  Future<List<Topic>> evaluateTopics(List<String> rawTopics) async {
    final prompt = Prompts.trendEvaluationPrompt(rawTopics);
    final text = await _generateResponse(prompt);

    final Map<String, dynamic> jsonMap = _parseJson(text) as Map<String, dynamic>;
    final List<dynamic> jsonList = jsonMap['topics'] as List<dynamic>? ?? [];
    return jsonList.map((e) => Topic.fromJson(e as Map<String, dynamic>)).toList()
      ..sort((a, b) => b.score.compareTo(a.score));
  }

  /// Step 3: Generate SEO data for a topic
  Future<SeoData> generateSeoData(Topic topic) async {
    final prompt = Prompts.seoResearchPrompt(topic.title);
    final text = await _generateResponse(prompt);
    return SeoData.fromJson(_parseJson(text) as Map<String, dynamic>);
  }

  /// Step 4: Generate full blog content (Broken down into multiple requests)
  Future<BlogContent> generateBlogContent(Topic topic, SeoData seo) async {
    // 1. Generate Outline
    final outlinePrompt = Prompts.blogOutlinePrompt(topic.title, seo.primaryKeyword);
    final outlineText = await _generateResponse(outlinePrompt);
    final outlineJson = _parseJson(outlineText) as Map<String, dynamic>;
    final List<dynamic> sections = outlineJson['sections'] ?? [];

    if (sections.isEmpty) {
      throw Exception('Failed to generate article outline.');
    }

    // 2. Generate Sections
    final StringBuffer fullMarkdown = StringBuffer();
    // Add title as H1
    fullMarkdown.writeln('# ${topic.title}\n');

    for (var section in sections) {
      final sectionTitle = _safeString(section['title']);
      final sectionDesc = _safeString(section['description']);
      
      final sectionPrompt = Prompts.blogSectionGenerationPrompt(
        topic.title, seo.primaryKeyword, sectionTitle, sectionDesc
      );
      final sectionText = await _generateResponse(sectionPrompt);
      final sectionJson = _parseJson(sectionText) as Map<String, dynamic>;
      
      fullMarkdown.writeln(sectionJson['markdown'] ?? '');
      fullMarkdown.writeln('\n');
    }

    // 3. Extract Metadata
    final metadataPrompt = Prompts.blogMetadataExtractionPrompt(
      topic.title, seo.primaryKeyword, fullMarkdown.toString()
    );
    final metadataText = await _generateResponse(metadataPrompt);
    final metadataJson = _parseJson(metadataText) as Map<String, dynamic>;

    return BlogContent(
      title: metadataJson['title'] != null ? _safeString(metadataJson['title']) : topic.title,
      introduction: _safeString(metadataJson['introduction']),
      fullArticleMarkdown: fullMarkdown.toString().trim(),
      faqItems: (metadataJson['faqItems'] as List?)?.map((e) => _safeString(e)).toList() ?? [],
      internalLinkingSuggestions: (metadataJson['internalLinkingSuggestions'] as List?)?.map((e) => _safeString(e)).toList() ?? [],
      wordCount: fullMarkdown.toString().split(RegExp(r'\s+')).length,
    );
  }

  /// Step 5: Generate article metadata
  Future<ArticleMetadata> generateMetadata(Article article) async {
    final prompt = Prompts.metadataPrompt(
      article.content.title,
      article.seo.primaryKeyword,
      article.topic.keywords.isNotEmpty ? article.topic.keywords.first : '',
    );
    final text = await _generateResponse(prompt);
    return ArticleMetadata.fromJson(_parseJson(text) as Map<String, dynamic>);
  }

  /// Step 6: Generate image prompts
  Future<ImagePackage> generateImagePackage(Topic topic) async {
    final prompt = Prompts.imagePromptGenerationPrompt(topic.title);
    final text = await _generateResponse(prompt);
    return ImagePackage.fromJson(_parseJson(text) as Map<String, dynamic>);
  }

  /// Step 7: AI Search Optimization — E-E-A-T, AEO, GEO, AISEO, LLMO
  Future<AiSearchOptimizationData> generateAiSearchOptimization({
    required String articleTitle,
    required String primaryKeyword,
    required String fullArticleMarkdown,
  }) async {
    final prompt = Prompts.aiSearchOptimizationPrompt(
      articleTitle,
      primaryKeyword,
      fullArticleMarkdown,
    );
    final text = await _generateResponse(prompt);
    return AiSearchOptimizationData.fromJson(
        _parseJson(text) as Map<String, dynamic>);
  }
}
