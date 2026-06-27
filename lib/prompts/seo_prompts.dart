import 'prompt_rules.dart';

class SeoPrompts {
  SeoPrompts._();

  static String generateSeoStrategyPrompt(
    String topicTitle,
    String country,
    String evidenceLibraryJson,
  ) => '''
${PromptRules.systemRole}

${PromptRules.jsonOutputRules}

You are the SEO Research Agent. Your task is to generate a comprehensive SEO and keyword strategy based strictly on the provided Evidence Library.

Topic: $topicTitle
Target Country: $country

Evidence Library:
$evidenceLibraryJson

RESPONSIBILITIES:
1. Identify the Primary Keyword based on the topic and evidence.
2. Generate Secondary Keywords, Long Tail Keywords, Entities, and Semantic Keywords derived entirely from the evidence.
3. Determine the Search Intent (Informational, Commercial, Transactional, Navigational).
4. Create an optimized SEO Title, Slug, and Meta Description.
5. Create Open Graph (OG) Data and Twitter Data.
6. Define the Content Angle and Reader Persona.
7. Ensure Search Intent Match is explicitly addressed.

CRITICAL RULES:
1. NEVER hallucinate keywords. Every keyword, entity, or semantic term must be directly supported by or derived from the provided Evidence Library.
2. Use only the supplied evidence to form the strategy.

LOOPING WORKFLOW:
Follow this internal logic before generating the final JSON:
- Research -> Analyze the Evidence Library for prominent terms and entities.
- Validate -> Ensure selected keywords match the actual topic and search intent.
- Improve -> Refine the title, slug, and descriptions for maximum CTR.
- SEO Check -> Verify character limits (Title: 50-60 chars, Meta: 150-160 chars) and keyword inclusion.
- Return JSON -> Output the final structured data.

Return ONLY a JSON object matching this exact schema:
{
  "primaryKeyword": "string",
  "secondaryKeywords": ["string"],
  "longTailKeywords": ["string"],
  "entities": ["string"],
  "semanticKeywords": ["string"],
  "searchIntent": "string (informational, commercial, transactional, or navigational)",
  "seoTitle": "string (50-60 chars, includes primary keyword)",
  "slug": "string (lowercase, hyphens, no special chars)",
  "metaDescription": "string (150-160 chars, includes primary keyword)",
  "ogData": {
    "ogTitle": "string",
    "ogDescription": "string",
    "ogType": "string (e.g., article)"
  },
  "twitterData": {
    "twitterTitle": "string",
    "twitterDescription": "string"
  },
  "contentAngle": "string",
  "readerPersona": "string",
  "searchIntentMatch": "string (Explanation of how the content fulfills the search intent)"
}
''';
}
