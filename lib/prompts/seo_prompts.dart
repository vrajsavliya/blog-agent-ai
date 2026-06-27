class SeoPrompts {
  SeoPrompts._();

  static String seoStrategyPrompt(String topicTitle) => '''
You are an expert SEO Researcher. Create an SEO strategy for the following topic:

Topic: $topicTitle

Analyze the search intent and generate semantic keywords.
Return a JSON object matching this exact schema:
{
  "primaryKeyword": { "type": "string" },
  "semanticKeywords": { "type": "array", "items": { "type": "string" } },
  "searchIntent": { "type": "string", "enum": ["informational", "commercial", "transactional", "navigational"] },
  "contentGaps": { "type": "array", "items": { "type": "string" } },
  "recommendedHeadings": { "type": "array", "items": { "type": "string" } }
}
''';
}
