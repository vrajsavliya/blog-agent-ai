class EvidencePrompts {
  EvidencePrompts._();

  static String extractEvidencePrompt(String rawSearchText) => '''
You are an Evidence Extraction Agent. Extract verifiable facts from the provided search results.

Raw Search Results:
$rawSearchText

Extract statistics, official definitions, FAQs, publication dates, and quotes. Discard unreliable sources.
Return a JSON object matching the Evidence Library schema:
{
  "sources": [
    {
      "id": "string",
      "title": "string",
      "url": "string (format: uri)",
      "publisher": "string",
      "author": "string",
      "publicationDate": "string",
      "authorityLevel": "integer (1-10)",
      "trustScore": "number",
      "keyFacts": ["string"],
      "statistics": ["string"],
      "quotes": ["string"]
    }
  ]
}
''';
}
