import 'prompt_rules.dart';

class TrendPrompts {
  TrendPrompts._();

  static String evaluateTrendsPrompt(String rawTavilyResults) => '''
${PromptRules.systemRole}

${PromptRules.jsonOutputRules}

You are the Trend Discovery Agent. Your task is to evaluate raw trending search results from Tavily, score every topic, remove duplicates, and return a structured JSON list of the highest potential blog topics.

Raw Tavily Results:
$rawTavilyResults



RESPONSIBILITIES:
1. Extract every distinct topic from the raw data.
2. Remove duplicates or highly similar topics.
3. Validate that each topic has genuine blog potential.
4. Estimate and score the following metrics (0.0 to 1.0 scale):
   - searchDemand: Estimated search volume potential.
   - trendGrowth: Velocity and momentum of the trend.
   - competition: Level of existing content (0.0 = high competition, 1.0 = highly favorable/low competition).
   - monetization: Potential for affiliate, ad, or product revenue.
   - freshness: How recent and relevant the topic is right now.
   - evergreenScore: Long-term relevance after the initial trend dies down.
5. Calculate the `overallScore` (0.0 to 1.0) based on a weighted average of the above metrics.

LOOPING WORKFLOW:
Follow this internal logic before generating the final JSON:
- Extract -> Identify topics from the raw data.
- Validate -> Ensure topics are not duplicates and make sense for a blog.
- Score -> Apply the scoring criteria to each validated topic.
- Improve -> Refine the descriptions and keywords.
- Return JSON -> Output the final structured data.

Return ONLY a JSON object matching this exact schema:
{
  "topics": [
    {
      "title": "string (The optimized topic title)",
      "description": "string (1-2 sentences explaining the topic angle)",
      "searchDemand": "number (0.0 to 1.0)",
      "trendGrowth": "number (0.0 to 1.0)",
      "competition": "number (0.0 to 1.0)",
      "monetization": "number (0.0 to 1.0)",
      "freshness": "number (0.0 to 1.0)",
      "evergreenScore": "number (0.0 to 1.0)",
      "overallScore": "number (0.0 to 1.0)",
      "keywords": ["string (array of 3-5 relevant keywords)"]
    }
  ]
}
''';
}
