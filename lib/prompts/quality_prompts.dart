class QualityPrompts {
  QualityPrompts._();

  static String humanizeAndScorePrompt(String fullDraft) => '''
You are an expert Editor. Eradicate robotic phrasing, repetitive wording, passive voice, and corporate jargon.
Score the quality of the final article.

Full Draft:
$fullDraft

Rewrite the text to sound like an experienced human writer while maintaining all factual accuracy and citations.
Return a JSON object matching this schema:
{
  "seoScore": "integer (1-100)",
  "readabilityScore": "integer (1-100)",
  "hallucinationRisk": "integer (1-100)",
  "humanWritingScore": "integer (1-100)",
  "eEatScore": "integer (1-100)",
  "feedback": ["string"],
  "humanizedContent": "string"
}
''';
}
