import 'prompt_rules.dart';

class YoastPrompts {
  YoastPrompts._();

  static String yoastOptimizationPrompt(
    String fullArticleMarkdown,
    String primaryKeyword,
  ) => '''
${PromptRules.systemRole}
${PromptRules.jsonOutputRules}

You are the Yoast Optimization Agent. Your task is to critically analyze the finalized article against strict SEO and readability metrics, simulating a comprehensive Yoast SEO Analysis.

Primary Keyword: $primaryKeyword

Article Content:
---
$fullArticleMarkdown
---

YOAST SEO VALIDATION CHECKLIST:
Evaluate the article against these rules:
1. Primary keyword appears in SEO title
2. Primary keyword starts the title
3. Primary keyword appears in URL slug
4. Primary keyword appears in meta description
5. Primary keyword appears in first sentence
6. Primary keyword appears in first paragraph
7. Primary keyword appears in Introduction heading
8. Primary keyword appears in at least two H2 headings
9. Primary keyword appears in one H3 heading
10. Primary keyword appears naturally throughout the article
11. Keyword density between 0.8% and 1.8%
12. Primary keyword appears in conclusion
13. Primary keyword appears in image ALT
14. Minimum 300 words
15. Preferred 1800-2500 words
16. At least 5 internal links
17. At least 5 external authority links
18. FAQ contains keyword naturally
19. Schema uses keyword
20. No keyword stuffing

If any rule fails:
Rewrite ONLY the failed section or element to fix the issue.

Return ONLY a JSON object matching this exact schema:
{
  "passedChecks": [
    "string (List the rules that passed)"
  ],
  "failedChecks": [
    "string (List the rules that failed)"
  ],
  "fixesApplied": [
    "string (Describe the changes you made to fix the failed checks)"
  ],
  "revisedSections": [
    {
      "originalHeading": "string (The heading of the section that was rewritten, or 'metadata' if it's a title/slug/meta description)",
      "revisedContent": "string (The newly rewritten Markdown content for this specific section)"
    }
  ]
}
''';
}
