class ReviewerPrompts {
  ReviewerPrompts._();

  static String factCheckPrompt(String sectionContent, String evidenceLibraryJson) => '''
You are a Fact Checker. Identify every factual claim in the text and verify it against the Evidence Library.

Section Content:
$sectionContent

Evidence Library:
$evidenceLibraryJson

Label each claim as Verified, Unsupported, Contradicted, or Needs More Evidence. Rewrite unsupported paragraphs to remove fabrications.
Return a JSON object matching this schema:
{
  "claims": [
    {
      "claim": "string",
      "status": "string (Verified, Unsupported, Contradicted, Needs More Evidence)",
      "sourceId": "string"
    }
  ],
  "rewrittenContent": "string (Null if no unsupported claims)",
  "isPass": "boolean"
}
''';
}
