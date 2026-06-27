class EvidenceSource {
  final String id;
  final String title;
  final String url;
  final String publisher;
  final String author;
  final String publicationDate;
  final int authorityLevel;
  final num trustScore;
  final List<String> keyFacts;
  final List<String> statistics;
  final List<String> quotes;

  EvidenceSource({
    required this.id,
    required this.title,
    required this.url,
    required this.publisher,
    required this.author,
    required this.publicationDate,
    required this.authorityLevel,
    required this.trustScore,
    required this.keyFacts,
    required this.statistics,
    required this.quotes,
  });

  factory EvidenceSource.fromJson(Map<String, dynamic> json) => EvidenceSource(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        url: json['url']?.toString() ?? '',
        publisher: json['publisher']?.toString() ?? '',
        author: json['author']?.toString() ?? '',
        publicationDate: json['publicationDate']?.toString() ?? '',
        authorityLevel: json['authorityLevel'] as int? ?? 5,
        trustScore: json['trustScore'] as num? ?? 0.0,
        keyFacts: (json['keyFacts'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
        statistics: (json['statistics'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
        quotes: (json['quotes'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'url': url,
        'publisher': publisher,
        'author': author,
        'publicationDate': publicationDate,
        'authorityLevel': authorityLevel,
        'trustScore': trustScore,
        'keyFacts': keyFacts,
        'statistics': statistics,
        'quotes': quotes,
      };
}

class EvidenceLibrary {
  final List<EvidenceSource> sources;

  EvidenceLibrary({required this.sources});

  factory EvidenceLibrary.fromJson(Map<String, dynamic> json) => EvidenceLibrary(
        sources: (json['sources'] as List<dynamic>? ?? [])
            .map((e) => EvidenceSource.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'sources': sources.map((e) => e.toJson()).toList(),
      };
}
