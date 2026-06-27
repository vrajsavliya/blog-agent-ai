class CompetitorPrompts {
  CompetitorPrompts._();

  static String analyzeCompetitorsPrompt(String competitorData) => '''
You are a Competitor Analysis Agent. Analyze the top ranking pages for the target keyword.

Competitor Data:
$competitorData

Extract headings, FAQs, missing topics, content gaps, and statistics used by competitors.
Return a JSON object matching this schema:
{
  "competitorHeadings": ["string"],
  "commonFaqs": ["string"],
  "contentGaps": ["string"],
  "statisticsUsed": ["string"]
}
''';
}
