import 'prompt_rules.dart';

class QualityPrompts {
  QualityPrompts._();

  static String finalQualityAssurancePrompt(
    String finalArticleJson,
    String evidenceLibraryJson,
    String seoResearchJson,
  ) => '''
${PromptRules.systemRole}

${PromptRules.jsonOutputRules}
${PromptRules.googleHelpfulContentRules}
${PromptRules.eeatRules}
${PromptRules.aeoRules}
${PromptRules.geoRules}
${PromptRules.aiSeoRules}
${PromptRules.llmoRules}

You are the Quality Assurance Agent. Your ultimate task is to evaluate the fully polished article against the most rigorous SEO and quality standards before it goes to production.

Final Article:
$finalArticleJson

Evidence Library:
$evidenceLibraryJson

SEO Research:
$seoResearchJson

RESPONSIBILITIES:
Evaluate the article on a scale of 0 to 100 for each of the following criteria:
- SEO
- Originality
- Readability
- Trustworthiness
- Evidence Coverage
- Citation Coverage
- Human Writing
- Helpfulness
- Google Helpful Content
- E-E-A-T
- AEO
- GEO
- AISEO
- LLMO
- Hallucination Risk (Must be 0 to pass)

CRITICAL RULE:
If ANY quality score is < 95, or if Hallucination Risk is > 0, you MUST identify the failed sections and suggest specific improvements.

LOOPING WORKFLOW:
Follow this internal logic before generating the final JSON:
- Evaluate -> Thoroughly score the article against all metrics.
- Improve -> Formulate specific, actionable improvements for any score under 95.
- Reevaluate -> Double-check the identified issues against the text.
- Return JSON -> Output the final evaluation data.

Return ONLY a JSON object matching this exact schema:
{
  "scores": {
    "seo": "integer (0-100)",
    "originality": "integer (0-100)",
    "readability": "integer (0-100)",
    "trustworthiness": "integer (0-100)",
    "evidenceCoverage": "integer (0-100)",
    "citationCoverage": "integer (0-100)",
    "humanWriting": "integer (0-100)",
    "helpfulness": "integer (0-100)",
    "googleHelpfulContent": "integer (0-100)",
    "eeat": "integer (0-100)",
    "aeo": "integer (0-100)",
    "geo": "integer (0-100)",
    "aiSeo": "integer (0-100)",
    "llmo": "integer (0-100)",
    "hallucinationRisk": "integer (0-100, 0 is perfect)"
  },
  "isProductionReady": "boolean (true ONLY if all quality scores are >= 95 and hallucinationRisk == 0)",
  "failedSections": [
    {
      "sectionHeading": "string",
      "reasonForFailure": "string",
      "suggestedImprovement": "string"
    }
  ]
}
''';
}
