class OutlinePrompts {
  OutlinePrompts._();

  static String generateOutlinePrompt(String topicTitle, String primaryKeyword, String evidenceSummary) => '''
You are an expert blog content strategist. Create a comprehensive article outline based on the evidence.

Topic: $topicTitle
Primary Keyword: $primaryKeyword
Evidence Summary: $evidenceSummary

Return a JSON object with this exact field:
{
  "sections": [
    {
      "sectionId": "string (unique identifier)",
      "title": "string (the H2 or H3 heading)",
      "description": "string (a brief instruction of what to cover, mapping to evidence)"
    }
  ]
}
''';
}
