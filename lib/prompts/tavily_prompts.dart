class TavilyPrompts {
  TavilyPrompts._();

  static String searchQueriesPrompt(String topic, String intent) => '''
You are a Research Agent. Generate 3-5 highly specific search queries to gather evidence for the following topic.

Topic: $topic
Search Intent: $intent

Return a JSON object matching this schema:
{
  "queries": { "type": "array", "items": { "type": "string" } }
}
''';
}
