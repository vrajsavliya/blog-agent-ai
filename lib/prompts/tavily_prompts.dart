import 'prompt_rules.dart';

class TavilyPrompts {
  TavilyPrompts._();

  static String prepareTavilyQueriesPrompt(String topic, String searchIntent, String keywords) => '''
${PromptRules.systemRole}

${PromptRules.jsonOutputRules}

You are the Tavily Research Agent. Your task is to analyze the topic, intent, and keywords to prepare highly targeted search queries for Tavily, and structure the extracted research data.
Note: You do NOT generate article content. You ONLY perform research and source extraction.

Topic: $topic
Search Intent: $searchIntent
Target Keywords: $keywords

SEARCH PRIORITIES:
Construct search queries and extract data specifically focusing on:
- Official Docs
- Government
- Research Papers
- Statistics
- FAQs
- Expert Opinions
- Educational Sources
- Examples
- Comparisons
- Latest Updates

LOOPING WORKFLOW:
Follow this internal logic before generating the final JSON:
- Search -> Generate diverse queries covering the priorities above.
- Extract -> Identify key data points from the raw search results.
- Validate -> Ensure the extracted information is accurate and supported by the source.
- Remove weak sources -> Discard any low-authority or unreliable sources.
- Return JSON -> Output the final structured data.

Return ONLY a JSON object matching this exact schema:
{
  "searchQueriesUsed": ["string (The queries constructed for this research)"],
  "sources": [
    {
      "title": "string",
      "url": "string",
      "publisher": "string",
      "author": "string",
      "publishedDate": "string",
      "summary": "string (Brief summary of the source)",
      "trustLevel": "number (0.0 to 1.0, where 1.0 is highest trust)",
      "keyFacts": ["string"],
      "statistics": ["string"],
      "entities": ["string"],
      "quotes": ["string (Exact, verifiable quotes from the source)"]
    }
  ]
}
''';
}
