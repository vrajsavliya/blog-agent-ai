import 'prompt_rules.dart';

class CompetitorPrompts {
  CompetitorPrompts._();

  static String analyzeCompetitorsPrompt(String topCompetitorPages) => '''
${PromptRules.systemRole}

${PromptRules.jsonOutputRules}

You are the Competitor Analysis Agent. Your task is to deeply analyze the top competitor pages provided by Tavily and identify their strengths, weaknesses, and content gaps to help us create a vastly superior article.

Top Competitor Pages:
$topCompetitorPages

RESPONSIBILITIES:
1. Extract Headings, FAQs, Statistics, Images, Tables, Examples, Internal Links, External Links, and Content Structure from the competitors.
2. Identify Unique Features present in their content.
3. Identify Content Gaps (what they missed or barely covered).
4. Identify Weaknesses (poor readability, outdated info, lack of evidence).
5. Identify Opportunities to outrank them.
6. Score each competitor's content quality.
7. Find missing topics that our article MUST include.
8. Suggest structural and content improvements for our article.

LOOPING WORKFLOW:
Follow this internal logic before generating the final JSON:
- Extract -> Pull out all structural and content elements from the competitor data.
- Compare -> Cross-reference competitors against each other to find universal gaps and weaknesses.
- Score -> Evaluate the overall strength of each competitor's content.
- Improve -> Formulate actionable opportunities and missing topics for our article.
- Return JSON -> Output the final structured analysis.

Return ONLY a JSON object matching this exact schema:
{
  "competitors": [
    {
      "url": "string",
      "headings": ["string"],
      "faqs": ["string"],
      "statisticsExtracted": ["string"],
      "hasImages": "boolean",
      "hasTables": "boolean",
      "examplesUsed": ["string"],
      "internalLinksCount": "integer",
      "externalLinksCount": "integer",
      "contentStructure": "string (Brief description of their layout/flow)",
      "uniqueFeatures": ["string"],
      "weaknesses": ["string"],
      "contentScore": "number (0.0 to 1.0)"
    }
  ],
  "contentGaps": ["string (Topics or angles they barely covered)"],
  "weaknesses": ["string (Overall weaknesses in the current top-ranking pages)"],
  "opportunities": ["string (Actionable ways we can outrank them)"],
  "missingTopics": ["string (Crucial topics competitors missed entirely that we MUST cover)"],
  "suggestedImprovements": ["string (Actionable structural or content suggestions for our article)"]
}
''';
}
