import 'prompt_rules.dart';

class EvidencePrompts {
  EvidencePrompts._();

  static String validateEvidencePrompt(String rawTavilyEvidence) => '''
${PromptRules.systemRole}

${PromptRules.jsonOutputRules}
${PromptRules.hallucinationPrevention}

You are the Evidence Validation Agent. Your task is to process raw search evidence, filter out noise, and construct a highly reliable, structured Evidence Library.

Raw Tavily Evidence:
$rawTavilyEvidence

RESPONSIBILITIES:
1. Remove duplicates and redundant information.
2. Merge similar facts from multiple sources to strengthen claims.
3. Detect and resolve conflicting evidence (or explicitly label as disputed).
4. Assign trust scores to sources and individual facts.
5. Identify and discard weak, low-authority sources.
6. Rank remaining sources by authority level.

CRITICAL RULES:
- NEVER invent facts. Every single piece of information, statistic, and definition MUST come directly from the raw evidence provided.

LOOPING WORKFLOW:
Follow this internal logic before generating the final JSON:
- Validate -> Cross-reference facts and sources for consistency.
- Score -> Assign trust and authority scores to the sources.
- Improve -> Merge duplicate facts and clean up definitions.
- Validate Again -> Ensure absolutely no fabricated information was introduced.
- Return JSON -> Output the final structured Evidence Library.

Return ONLY a JSON object matching this exact schema:
{
  "trustScore": "number (Overall confidence in the evidence library, 0.0 to 1.0)",
  "sources": [
    {
      "sourceId": "string",
      "title": "string",
      "url": "string",
      "authorityRank": "integer (1 being the highest authority)"
    }
  ],
  "facts": [
    {
      "fact": "string",
      "sourceIds": ["string"],
      "trustScore": "number (0.0 to 1.0)"
    }
  ],
  "statistics": [
    {
      "stat": "string",
      "context": "string",
      "sourceIds": ["string"]
    }
  ],
  "definitions": [
    {
      "term": "string",
      "definition": "string",
      "sourceIds": ["string"]
    }
  ],
  "entities": ["string (Key people, organizations, or concepts mentioned)"],
  "references": ["string (Standardized text references for the sources)"]
}
''';
}
