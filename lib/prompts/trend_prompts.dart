class TrendPrompts {
  TrendPrompts._();

  static String topicEvaluationPrompt(String keyword) => '''
You are an expert Content Strategist. Evaluate the following topic/keyword for a blog post.

Topic: $keyword

Evaluate the topic's trend potential, target audience, and primary angle.
Return a JSON object matching this exact schema:
{
  "trendScore": { "type": "integer", "description": "1-100 score based on current relevance" },
  "targetAudience": { "type": "string" },
  "primaryAngle": { "type": "string" },
  "contentPillars": { "type": "array", "items": { "type": "string" } }
}
''';
}
