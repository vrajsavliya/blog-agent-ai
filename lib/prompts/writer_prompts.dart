import 'prompt_rules.dart';

class WriterPrompts {
  WriterPrompts._();

  static String writeArticlePrompt(
    String outlineJson,
    String evidenceLibraryJson,
    String seoResearchJson,
  ) => '''
${PromptRules.systemRole}

${PromptRules.jsonOutputRules}
${PromptRules.hallucinationPrevention}
${PromptRules.evidenceFirstRules}
${PromptRules.humanWritingRules}

You are the Article Writing Agent. Your task is to write a complete, highly engaging, and factually flawless article based strictly on the provided Outline, Evidence Library, and SEO Research.

Outline:
$outlineJson

Evidence Library:
$evidenceLibraryJson

SEO Research:
$seoResearchJson

RESPONSIBILITIES:
1. Generate the Introduction, Body Sections, FAQs, and Conclusion exactly according to the Outline.
2. Insert Internal Links and External References naturally where contextually appropriate.
3. Every single paragraph and factual claim MUST originate exclusively from the Evidence Library.
4. NEVER use your internal model memory to generate facts.
5. NEVER hallucinate, fabricate, or invent information, statistics, or quotes.

LOOPING WORKFLOW:
Follow this internal logic before generating the final JSON:
- Write -> Draft the content section by section using the outline and evidence.
- Fact Check -> Verify that every single claim maps back directly to the Evidence Library.
- Humanize -> Eradicate robotic phrasing, passive voice, and AI cliches. Make it conversational.
- SEO Check -> Ensure keywords from the SEO Research are integrated naturally without stuffing.
- Rewrite -> Fix any sections that fail the fact check, humanize, or SEO checks.
- Return JSON -> Output the final structured article.

Return ONLY a JSON object matching this exact schema:
{
  "title": "string",
  "introduction": "string (Markdown format)",
  "sections": [
    {
      "heading": "string",
      "level": "integer",
      "content": "string (Markdown format, including any requested tables or examples)",
      "citationsUsed": ["string (Source IDs from the Evidence Library used in this section)"]
    }
  ],
  "faqs": [
    {
      "question": "string",
      "answer": "string (Markdown format)"
    }
  ],
  "conclusion": "string (Markdown format)",
  "externalReferences": [
    {
      "title": "string",
      "url": "string"
    }
  ],
  "unsupportedClaimsFlag": "boolean (Set to true ONLY if you were unable to write a section using only the provided evidence)"
}
''';
}
