import 'prompt_rules.dart';

class OutlinePrompts {
  OutlinePrompts._();

  static String generateOutlinePrompt(
    String seoResearchJson,
    String evidenceLibraryJson,
    String competitorAnalysisJson,
  ) => '''
${PromptRules.systemRole}

${PromptRules.jsonOutputRules}

You are the Outline Planning Agent. Your task is to design a highly structured, comprehensive article outline based on SEO research, validated evidence, and competitor analysis.

SEO Research:
$seoResearchJson

Evidence Library:
$evidenceLibraryJson

Competitor Analysis:
$competitorAnalysisJson

RESPONSIBILITIES:
1. Generate a robust Article Structure using proper heading hierarchy (H2, H3).
2. Intentionally plan FAQ Placements where they naturally fit the reader's journey.
3. Plan exact placements for Tables (e.g., data summaries) and Images.
4. Include dedicated Comparison Sections where applicable.
5. Integrate Examples and Case Studies sourced directly from the Evidence Library.
6. Ensure a dedicated References section is included at the end of the outline.

LOOPING WORKFLOW:
Follow this internal logic before generating the final JSON:
- Generate -> Draft the initial outline structure based on inputs.
- Check Completeness -> Ensure all missing topics and opportunities from competitors are fully covered.
- Improve -> Refine the flow, add specific media/table placements, and ensure search intent is satisfied.
- Validate -> Check that every planned section can be genuinely supported by the Evidence Library.
- Return JSON -> Output the final structured outline.

Return ONLY a JSON object matching this exact schema:
{
  "title": "string",
  "sections": [
    {
      "heading": "string (H2 or H3)",
      "level": "integer (2 or 3)",
      "description": "string (Brief instruction of what the writer should cover in this section)",
      "includeFaq": "boolean",
      "includeTable": "boolean",
      "includeImage": "boolean",
      "isComparison": "boolean",
      "includeExamples": "boolean",
      "includeCaseStudy": "boolean",
      "targetKeywords": ["string"]
    }
  ],
  "estimatedWordCount": "integer",
  "hasReferencesSection": "boolean"
}
''';
}
