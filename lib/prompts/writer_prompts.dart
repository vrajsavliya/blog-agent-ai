class WriterPrompts {
  WriterPrompts._();

  static String writeSectionPrompt(String sectionTitle, String sectionDesc, String evidenceLibraryJson) => '''
You are an expert blog writer. Write the content for ONE specific section of an article.

Section Heading: $sectionTitle
Section Instructions: $sectionDesc
Evidence Library:
$evidenceLibraryJson

CRITICAL RULES:
- You must ONLY use facts from the Evidence Library.
- Cite sources inline using [Source ID].
- Do not fabricate any information.
- Write naturally but factually.

Return a JSON object with this exact schema:
{
  "sectionId": "string",
  "content": "string (Markdown format)",
  "citationsUsed": ["string (Source IDs)"],
  "unsupportedClaimsFlag": "boolean (true if you could not fulfill instructions using only evidence)"
}
''';
}
