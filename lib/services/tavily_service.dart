import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TavilyService {
  static const String _baseUrl = 'https://api.tavily.com';

  late final Dio _dio;

  TavilyService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));
  }

  String get _apiKey => dotenv.env['TAVILY_API_KEY'] ?? '';

  /// Fetches trending topics across AI, tech, startups, and developer communities.
  /// If [customQuery] is provided, it searches for news related to that query instead.
  /// If [domain] is provided, it restricts the broad search to that domain.
  Future<List<String>> fetchTrendingTopics({String? customQuery, String? domain}) async {
    final domainSuffix = domain != null && domain.trim().isNotEmpty ? ' in ${domain.trim()}' : '';
    final allPossibleQueries = [
      'latest technology breakthroughs$domainSuffix',
      'trending news$domainSuffix',
      'new releases and updates$domainSuffix',
      'innovations this week$domainSuffix',
      'market trends$domainSuffix',
      'latest developments$domainSuffix',
      'future trends$domainSuffix',
      'industry insights$domainSuffix',
    ];

    List<String> selectedQueries;

    if (customQuery != null && customQuery.trim().isNotEmpty) {
      selectedQueries = [
        'latest news about ${customQuery.trim()}$domainSuffix',
        'trending developments in ${customQuery.trim()}$domainSuffix',
        '${customQuery.trim()} innovations and updates$domainSuffix',
      ];
    } else {
      // Shuffle and pick 3 random queries to ensure varied results each time
      allPossibleQueries.shuffle();
      selectedQueries = allPossibleQueries.take(3).toList();
    }

    final List<String> allTopics = [];

    for (final query in selectedQueries) {
      try {
        final response = await _dio.post(
          '/search',
          data: {
            'api_key': _apiKey,
            'query': query,
            'search_depth': 'basic',
            'topic': 'news', // Forces Tavily to look at recent news
            'days': 3, // Restricts to last 3 days
            'include_answer': true,
            'include_raw_content': false,
            'max_results': 6,
          },
        );

        final results = response.data['results'] as List? ?? [];
        for (final result in results) {
          final title = result['title'] as String? ?? '';
          if (title.isNotEmpty && !allTopics.contains(title)) {
            allTopics.add(title);
          }
        }

        // Also extract from the answer if available
        final answer = response.data['answer'] as String?;
        if (answer != null && answer.isNotEmpty) {
          // Parse numbered list items from the answer
          final lines = answer.split('\n');
          for (final line in lines) {
            final cleaned = line
                .replaceAll(RegExp(r'^\d+\.\s*'), '')
                .replaceAll(RegExp(r'^\*\s*'), '')
                .trim();
            if (cleaned.length > 10 && !allTopics.contains(cleaned)) {
              allTopics.add(cleaned);
            }
          }
        }
      } catch (e) {
        // Continue with other queries if one fails
        continue;
      }
    }

    // Deduplicate and return top 15
    return allTopics.take(15).toList();
  }

  /// Research additional details about a specific topic
  Future<Map<String, dynamic>> researchTopic(String topic) async {
    try {
      final response = await _dio.post(
        '/search',
        data: {
          'api_key': _apiKey,
          'query': 'detailed information about: $topic',
          'search_depth': 'advanced',
          'include_answer': true,
          'max_results': 8,
        },
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }
}
