import 'topic_model.dart';
import '../utils/json_helper.dart';

class SeoData {
  final String primaryKeyword;
  final List<String> secondaryKeywords;
  final List<String> longTailKeywords;
  final String searchIntent;
  final String seoTitle;
  final String metaDescription;
  final String urlSlug;
  final String ogTitle;
  final String ogDescription;
  final String twitterTitle;
  final String twitterDescription;

  SeoData({
    required this.primaryKeyword,
    required this.secondaryKeywords,
    required this.longTailKeywords,
    required this.searchIntent,
    required this.seoTitle,
    required this.metaDescription,
    required this.urlSlug,
    required this.ogTitle,
    required this.ogDescription,
    required this.twitterTitle,
    required this.twitterDescription,
  });

  factory SeoData.fromJson(Map<String, dynamic> json) => SeoData(
        primaryKeyword: JsonHelper.safeString(json['primaryKeyword']),
        secondaryKeywords: JsonHelper.safeList(json['secondaryKeywords']),
        longTailKeywords: JsonHelper.safeList(json['longTailKeywords']),
        searchIntent: JsonHelper.safeString(json['searchIntent']),
        seoTitle: JsonHelper.safeString(json['seoTitle']),
        metaDescription: JsonHelper.safeString(json['metaDescription']),
        urlSlug: JsonHelper.safeString(json['urlSlug']),
        ogTitle: JsonHelper.safeString(json['ogTitle']),
        ogDescription: JsonHelper.safeString(json['ogDescription']),
        twitterTitle: JsonHelper.safeString(json['twitterTitle']),
        twitterDescription: JsonHelper.safeString(json['twitterDescription']),
      );

  Map<String, dynamic> toJson() => {
        'primaryKeyword': primaryKeyword,
        'secondaryKeywords': secondaryKeywords,
        'longTailKeywords': longTailKeywords,
        'searchIntent': searchIntent,
        'seoTitle': seoTitle,
        'metaDescription': metaDescription,
        'urlSlug': urlSlug,
        'ogTitle': ogTitle,
        'ogDescription': ogDescription,
        'twitterTitle': twitterTitle,
        'twitterDescription': twitterDescription,
      };
}

class BlogContent {
  final String title;
  final String introduction;
  final String fullArticleMarkdown;
  final List<String> faqItems;
  final List<String> internalLinkingSuggestions;
  final int wordCount;

  BlogContent({
    required this.title,
    required this.introduction,
    required this.fullArticleMarkdown,
    required this.faqItems,
    required this.internalLinkingSuggestions,
    required this.wordCount,
  });

  factory BlogContent.fromJson(Map<String, dynamic> json) => BlogContent(
        title: JsonHelper.safeString(json['title']),
        introduction: JsonHelper.safeString(json['introduction']),
        fullArticleMarkdown: JsonHelper.safeString(json['fullArticleMarkdown']),
        faqItems: JsonHelper.safeList(json['faqItems']),
        internalLinkingSuggestions:
            JsonHelper.safeList(json['internalLinkingSuggestions']),
        wordCount: json['wordCount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'introduction': introduction,
        'fullArticleMarkdown': fullArticleMarkdown,
        'faqItems': faqItems,
        'internalLinkingSuggestions': internalLinkingSuggestions,
        'wordCount': wordCount,
      };
}

class BlogImageInfo {
  final String prompt;
  final String altText;
  final String caption;
  final String placement;
  final String? localImagePath;
  final String? wordpressMediaId;
  final String? wordpressMediaUrl;

  BlogImageInfo({
    required this.prompt,
    required this.altText,
    required this.caption,
    required this.placement,
    this.localImagePath,
    this.wordpressMediaId,
    this.wordpressMediaUrl,
  });

  BlogImageInfo copyWith({
    String? localImagePath,
    String? wordpressMediaId,
    String? wordpressMediaUrl,
  }) {
    return BlogImageInfo(
      prompt: prompt,
      altText: altText,
      caption: caption,
      placement: placement,
      localImagePath: localImagePath ?? this.localImagePath,
      wordpressMediaId: wordpressMediaId ?? this.wordpressMediaId,
      wordpressMediaUrl: wordpressMediaUrl ?? this.wordpressMediaUrl,
    );
  }

  factory BlogImageInfo.fromJson(Map<String, dynamic> json) => BlogImageInfo(
        prompt: JsonHelper.safeString(json['prompt']),
        altText: JsonHelper.safeString(json['altText']),
        caption: JsonHelper.safeString(json['caption']),
        placement: JsonHelper.safeString(json['placement']),
        localImagePath: json['localImagePath'],
        wordpressMediaId: json['wordpressMediaId']?.toString(),
        wordpressMediaUrl: json['wordpressMediaUrl'],
      );

  Map<String, dynamic> toJson() => {
        'prompt': prompt,
        'altText': altText,
        'caption': caption,
        'placement': placement,
        if (localImagePath != null) 'localImagePath': localImagePath,
        if (wordpressMediaId != null) 'wordpressMediaId': wordpressMediaId,
        if (wordpressMediaUrl != null) 'wordpressMediaUrl': wordpressMediaUrl,
      };
}

class ImagePackage {
  final BlogImageInfo featuredImage;
  final List<BlogImageInfo> supportingImages;

  ImagePackage({required this.featuredImage, required this.supportingImages});

  factory ImagePackage.fromJson(Map<String, dynamic> json) => ImagePackage(
        featuredImage: BlogImageInfo.fromJson(json['featuredImage'] ?? {}),
        supportingImages: (json['supportingImages'] as List? ?? [])
            .map((e) => BlogImageInfo.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'featuredImage': featuredImage.toJson(),
        'supportingImages': supportingImages.map((e) => e.toJson()).toList(),
      };
}

class ArticleMetadata {
  final String metaTitle;
  final String metaDescription;
  final List<String> tags;
  final List<String> categories;
  final Map<String, String> openGraphData;

  ArticleMetadata({
    required this.metaTitle,
    required this.metaDescription,
    required this.tags,
    required this.categories,
    required this.openGraphData,
  });

  factory ArticleMetadata.fromJson(Map<String, dynamic> json) =>
      ArticleMetadata(
        metaTitle: JsonHelper.safeString(json['metaTitle']),
        metaDescription: JsonHelper.safeString(json['metaDescription']),
        tags: JsonHelper.safeList(json['tags']),
        categories: JsonHelper.safeList(json['categories']),
        openGraphData: Map<String, String>.from(json['openGraphData'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'metaTitle': metaTitle,
        'metaDescription': metaDescription,
        'tags': tags,
        'categories': categories,
        'openGraphData': openGraphData,
      };
}

enum PublishStatus { draft, saved, published, failed }

// ── AI Search Optimization Data ───────────────────────────────────────────────

class AiSearchOptimizationData {
  // AEO: Direct answer + featured snippet
  final String featuredSnippetAnswer;
  final String directAnswerSection;

  // Content summary & takeaways (LLMO + GEO)
  final String articleSummary;
  final List<String> keyTakeaways;

  // FAQ (AEO + Schema)
  final List<String> faqSection;

  // GEO: Citation-worthy references
  final List<String> sourcesAndReferences;

  // E-E-A-T signals
  final Map<String, String> eatSignals;

  // Schema Markup JSON-LD (Article + FAQPage + BreadcrumbList)
  final Map<String, dynamic> schemaMarkup;

  // LLMO: entity map & definitions
  final Map<String, String> llmFriendlyStructure;

  // AISEO: optimised SEO meta overrides
  final String optimizedSeoTitle;
  final String optimizedMetaDescription;
  final String optimizedUrlSlug;

  // Quality validation & scoring
  final Map<String, num> qualityScores;
  final Map<String, bool> qualityChecklist;

  AiSearchOptimizationData({
    required this.featuredSnippetAnswer,
    required this.directAnswerSection,
    required this.articleSummary,
    required this.keyTakeaways,
    required this.faqSection,
    required this.sourcesAndReferences,
    required this.eatSignals,
    required this.schemaMarkup,
    required this.llmFriendlyStructure,
    required this.optimizedSeoTitle,
    required this.optimizedMetaDescription,
    required this.optimizedUrlSlug,
    required this.qualityScores,
    required this.qualityChecklist,
  });

  factory AiSearchOptimizationData.fromJson(Map<String, dynamic> json) =>
      AiSearchOptimizationData(
        featuredSnippetAnswer: JsonHelper.safeString(json['featuredSnippetAnswer']),
        directAnswerSection: JsonHelper.safeString(json['directAnswerSection']),
        articleSummary: JsonHelper.safeString(json['articleSummary']),
        keyTakeaways: JsonHelper.safeList(json['keyTakeaways']),
        faqSection: JsonHelper.safeList(json['faqSection']),
        sourcesAndReferences: JsonHelper.safeList(json['sourcesAndReferences']),
        eatSignals: Map<String, String>.from(json['eatSignals'] ?? {}),
        schemaMarkup: Map<String, dynamic>.from(json['schemaMarkup'] ?? {}),
        llmFriendlyStructure:
            Map<String, String>.from(json['llmFriendlyStructure'] ?? {}),
        optimizedSeoTitle: JsonHelper.safeString(json['optimizedSeoTitle']),
        optimizedMetaDescription: JsonHelper.safeString(json['optimizedMetaDescription']),
        optimizedUrlSlug: JsonHelper.safeString(json['optimizedUrlSlug']),
        qualityScores: Map<String, num>.from(json['qualityScores'] ?? {}),
        qualityChecklist:
            Map<String, bool>.from(json['qualityChecklist'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'featuredSnippetAnswer': featuredSnippetAnswer,
        'directAnswerSection': directAnswerSection,
        'articleSummary': articleSummary,
        'keyTakeaways': keyTakeaways,
        'faqSection': faqSection,
        'sourcesAndReferences': sourcesAndReferences,
        'eatSignals': eatSignals,
        'schemaMarkup': schemaMarkup,
        'llmFriendlyStructure': llmFriendlyStructure,
        'optimizedSeoTitle': optimizedSeoTitle,
        'optimizedMetaDescription': optimizedMetaDescription,
        'optimizedUrlSlug': optimizedUrlSlug,
        'qualityScores': qualityScores,
        'qualityChecklist': qualityChecklist,
      };
}

class Article {
  final String id;
  final Topic topic;
  final SeoData seo;
  final BlogContent content;
  final ImagePackage images;
  final ArticleMetadata metadata;
  final PublishStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? wordpressPostId;
  final String userId;
  // nullable → backward compat with existing Firestore docs
  final AiSearchOptimizationData? aiOptimization;

  Article({
    required this.id,
    required this.topic,
    required this.seo,
    required this.content,
    required this.images,
    required this.metadata,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    this.wordpressPostId,
    this.aiOptimization,
  });

  Article copyWith({
    PublishStatus? status,
    String? wordpressPostId,
    DateTime? updatedAt,
    AiSearchOptimizationData? aiOptimization,
  }) =>
      Article(
        id: id,
        topic: topic,
        seo: seo,
        content: content,
        images: images,
        metadata: metadata,
        status: status ?? this.status,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        userId: userId,
        wordpressPostId: wordpressPostId ?? this.wordpressPostId,
        aiOptimization: aiOptimization ?? this.aiOptimization,
      );

  factory Article.fromFirestore(Map<String, dynamic> json, String docId) =>
      Article(
        id: docId,
        topic: Topic.fromJson(json['topic'] ?? {}),
        seo: SeoData.fromJson(json['seo'] ?? {}),
        content: BlogContent.fromJson(json['content'] ?? {}),
        images: ImagePackage.fromJson(json['images'] ?? {}),
        metadata: ArticleMetadata.fromJson(json['metadata'] ?? {}),
        status: PublishStatus.values.firstWhere(
          (e) => e.name == (json['status'] ?? 'draft'),
          orElse: () => PublishStatus.draft,
        ),
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : DateTime.now(),
        userId: json['userId'] ?? '',
        wordpressPostId: json['wordpressPostId'],
        aiOptimization: json['aiOptimization'] != null
            ? AiSearchOptimizationData.fromJson(
                Map<String, dynamic>.from(json['aiOptimization']))
            : null,
      );

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'topic': topic.toJson(),
        'seo': seo.toJson(),
        'content': content.toJson(),
        'images': images.toJson(),
        'metadata': metadata.toJson(),
        if (wordpressPostId != null) 'wordpressPostId': wordpressPostId,
        if (aiOptimization != null) 'aiOptimization': aiOptimization!.toJson(),
      };
}
