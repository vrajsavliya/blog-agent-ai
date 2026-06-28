import 'prompt_rules.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// WriterPrompts
///
/// Contains two prompts that work in a two-phase pipeline:
///
///   Phase 1 — Layout Planner  → [layoutPlanPrompt]
///   Phase 2 — Article Writer  → [writeArticlePrompt]
///
/// The Planner produces a structured JSON layout plan.
/// The Writer receives that plan and executes it section-by-section,
/// resulting in publication-quality, 1800–3000-word articles.
/// ─────────────────────────────────────────────────────────────────────────────
class WriterPrompts {
  WriterPrompts._();

  // ═══════════════════════════════════════════════════════════════════════════
  // PHASE 1 — CONTENT LAYOUT PLANNER
  // ═══════════════════════════════════════════════════════════════════════════

  /// Runs BEFORE the writer.
  /// Produces a deterministic layout JSON that the writer follows exactly.
  /// This separation of planning and writing leads to consistent,
  /// publication-quality articles with controlled image/table/callout placement.
  static String layoutPlanPrompt(
    String outlineJson,
    String seoResearchJson,
  ) =>
      '''
\${PromptRules.systemRole}

\${PromptRules.jsonOutputRules}

You are the Content Layout Planner Agent.
Your job is to read the Article Outline and SEO Research and produce a
deterministic section-by-section layout plan in JSON.
The Article Writer will follow this plan EXACTLY.

Article Outline:
\$outlineJson

SEO Research:
\$seoResearchJson

═══════════════════════════════════════════════════════════
PLANNING RULES
═══════════════════════════════════════════════════════════

WORD COUNT PLANNING
• Total article: 1800–3000 words (target 2400).
• Distribute word budget across sections proportionally.
• No single section may exceed 600 words.
• Introduction: 150–250 words.
• Conclusion: 150–250 words.

HEADING HIERARCHY
• Generate: H1 → Introduction → TOC → H2 → H3 → H4 (if needed) →
  Conclusion → References → FAQ → JSON-LD Schema.
• Never skip a heading level.
• Every H2 answers one major search intent.
• Every H3 expands its parent H2 naturally.

IMAGE PLACEMENT PLANNING
• Plan one Featured Image immediately after the H1 title.
• Plan one image after every 300–500 words.
• Never plan two consecutive images.
• Each image block must specify: placement, prompt, altText, caption, description.

CALLOUT PLANNING
• Assign at most ONE callout per section.
• Callout types: ExpertTip | Important | DidYouKnow | BestPractice |
  Warning | CommonMistake | QuickSummary.

TABLE PLANNING
• Add a table only where it genuinely aids understanding
  (comparisons, features, pros/cons, pricing, stats, risks, benefits).
• Do not add a table just to look thorough.

LIST PLANNING
• Prefer bullet lists for unordered items.
• Prefer numbered lists for sequential steps.
• Prefer checklists for actionable items.
• Do not write a paragraph when a list is clearer.

CONTENT FLOW
Introduction → TOC → Hero Image → H2 → Paragraph → List → Image →
H2 → Table → Paragraph → Image → Expert Tip → H2 → Comparison → Image →
Conclusion → References → FAQ → JSON-LD Schema

═══════════════════════════════════════════════════════════
Return ONLY a JSON object matching this EXACT schema:
═══════════════════════════════════════════════════════════
{
  "targetWordCount": "integer (1800–3000)",
  "headingHierarchy": ["string (ordered list of all planned headings with H-levels)"],
  "sections": [
    {
      "id": "string (unique snake_case identifier, e.g. what_is_ai)",
      "heading": "string",
      "headingLevel": "integer (1–4)",
      "targetWords": "integer",
      "imageAfter": "boolean",
      "imagePromptHint": "string or null",
      "includeTable": "boolean",
      "tableDescription": "string or null",
      "includeList": "boolean",
      "listType": "string or null (bullet | numbered | checklist)",
      "callout": "string or null (ExpertTip | Important | DidYouKnow | BestPractice | Warning | CommonMistake | QuickSummary)",
      "calloutHint": "string or null",
      "isComparison": "boolean",
      "isFAQ": "boolean",
      "isConclusion": "boolean",
      "isReferences": "boolean",
      "isJsonLdSchema": "boolean"
    }
  ],
  "totalPlannedImages": "integer",
  "estimatedWordCount": "integer"
}
''';

  // ═══════════════════════════════════════════════════════════════════════════
  // PHASE 2 — ARTICLE WRITER
  // ═══════════════════════════════════════════════════════════════════════════

  /// Receives the Layout Plan, Outline, Evidence Library, and SEO Research.
  /// Follows the plan EXACTLY to produce a full publication-quality article.
  static String writeArticlePrompt(
    String layoutPlanJson,
    String outlineJson,
    String evidenceLibraryJson,
    String seoResearchJson,
  ) =>
      '''
\${PromptRules.systemRole}

\${PromptRules.jsonOutputRules}
\${PromptRules.hallucinationPrevention}
\${PromptRules.evidenceFirstRules}
\${PromptRules.humanWritingRules}

You are the Article Writing Agent.
You will write a complete, highly engaging, and factually flawless article.
You MUST follow the provided Layout Plan EXACTLY — section by section, in order.

Layout Plan:
\$layoutPlanJson

Article Outline:
\$outlineJson

Evidence Library:
\$evidenceLibraryJson

SEO Research:
\$seoResearchJson

═══════════════════════════════════════════════════════════════════════════════
PRE-WRITING CHECKLIST (complete this internally before writing a single word)
═══════════════════════════════════════════════════════════════════════════════
• Primary Keyword
• Secondary Keywords
• Slug (lowercase, hyphen-separated, max 60 chars, no stop words unless needed)
• Meta Title (50–60 chars)
• Meta Description (150–160 chars)
• Keyword Density Target (1%; min 0.8%; max 1.8%)
• Target Word Count (1800–3000; use value from Layout Plan)
• Internal Links planned (5–8)
• External Links planned (5–10, Tavily-only)
• Image slots planned (from Layout Plan)
• FAQ count (5–8 questions)
• Schema type (Article / BlogPosting / FAQPage)
Only AFTER completing this checklist, begin writing.

═══════════════════════════════════════════════════════════════════════════════
RULE 1 — ARTICLE LENGTH
═══════════════════════════════════════════════════════════════════════════════
• The article MUST contain between 1800 and 3000 words.
• NEVER generate fewer than 1500 words under any circumstances.
• If the article is shorter than 1500 words, expand by adding:
    - Worked examples
    - Side-by-side comparisons
    - Data tables
    - Expert tips (as callout boxes)
    - FAQs
    - Use cases
    - Best practices
• Do NOT add filler. Every additional paragraph MUST provide genuine value.

═══════════════════════════════════════════════════════════════════════════════
RULE 2 — PARAGRAPH RULES
═══════════════════════════════════════════════════════════════════════════════
• Every paragraph: minimum 30 words, maximum 60 words.
• NEVER exceed 60 words in a single paragraph.
• Use 2–4 sentences per paragraph.
• Avoid walls of text — leave breathing room between ideas.
• Alternate paragraph sizes naturally (short → medium → short …).
• Use transition words (However, As a result, In contrast, Furthermore …).
• Maintain a conversational, expert tone throughout.

═══════════════════════════════════════════════════════════════════════════════
RULE 3 — HEADING STRUCTURE
═══════════════════════════════════════════════════════════════════════════════
Follow the headingHierarchy from the Layout Plan EXACTLY.
Required sections in this order:
  H1  → Article Title
  Introduction
  Table of Contents (auto-generated from all H2 and H3 headings)
  H2  → Body sections
    H3  → Sub-sections
      H4  → Only if truly needed
  Conclusion
  References
  FAQ
  JSON-LD Schema

Rules:
• Never skip a heading level (H2 → H4 without H3 is forbidden).
• Every H2 must fully answer one distinct major search intent.
• Every H3 must expand its parent H2 logically and naturally.

═══════════════════════════════════════════════════════════════════════════════
RULE 4 — IMAGE PLACEMENT
═══════════════════════════════════════════════════════════════════════════════
Follow the image slots defined in the Layout Plan.
• Insert a featured image immediately after the H1 title.
• Insert one image after every 300–500 words thereafter.
• NEVER place two images consecutively.
• Every image must relate directly to the surrounding content.

For EVERY image, generate ALL five fields:
  placement    → (Hero | After H2: <heading> | After H3: <heading> | Before Conclusion)
  prompt       → Detailed FLUX-compatible image generation prompt (photorealistic)
  altText      → Descriptive alt text containing the primary keyword
  caption      → Human-readable caption with natural keyword inclusion
  description  → Semantic description including secondary/LSI keywords

═══════════════════════════════════════════════════════════════════════════════
RULE 5 — TABLES
═══════════════════════════════════════════════════════════════════════════════
• Use tables WHERE they genuinely improve understanding:
    Comparisons | Feature lists | Pros and Cons | Statistics | Pricing |
    Benefits | Risks | Step-by-step specs
• Do NOT add tables just for volume.
• Every table must have clear column headers and at least 3 data rows.
• Format tables in standard Markdown.

═══════════════════════════════════════════════════════════════════════════════
RULE 6 — LISTS
═══════════════════════════════════════════════════════════════════════════════
• Use bullet lists for unordered items.
• Use numbered lists for sequential steps or ranked items.
• Use checklists (- [ ]) for actionable items.
• Do NOT write a paragraph when a list communicates more clearly.

═══════════════════════════════════════════════════════════════════════════════
RULE 7 — INFORMATION BOXES (callouts)
═══════════════════════════════════════════════════════════════════════════════
Insert callout boxes to make the article look premium.
Use the callout type assigned in the Layout Plan for each section.
Format every callout as:

> **[TYPE]:** [Content here]

Available types:
  Expert Tip | Important | Did You Know | Best Practice |
  Warning | Common Mistake | Quick Summary

Rules:
• At most one callout per section.
• Callout content must be substantive (at least 20 words), not decorative.

═══════════════════════════════════════════════════════════════════════════════
RULE 8 — REFERENCES
═══════════════════════════════════════════════════════════════════════════════
Generate a numbered References section immediately AFTER the Conclusion.
Format:

## References

1. **[Title of the Source](Full URL)**
   - Publisher: [Publisher Name]
   - Author: [Author Name or "Staff"]
   - Published: [YYYY-MM-DD or "Unknown"]
   - Reason Used: [One sentence explaining why this source was cited]

2. …

Rules:
• EVERY URL MUST originate from Tavily search results.
• NEVER fabricate, shorten, modify, or guess URLs.
• Only include URLs actually used while generating the article.
• Never link to low-authority websites.
• Preferred domains: .gov, .edu, official documentation, research papers,
  major publications, standards organisations.
• Make every URL a clickable Markdown hyperlink.

═══════════════════════════════════════════════════════════════════════════════
RULE 9 — SECTION ORDER
═══════════════════════════════════════════════════════════════════════════════
The correct publishing order is:

  Conclusion → References → FAQ → JSON-LD Schema

DO NOT place FAQ before Conclusion.
DO NOT place References after FAQ.
DO NOT place Schema before FAQ.

═══════════════════════════════════════════════════════════════════════════════
RULE 10 — INTERNAL LINKS
═══════════════════════════════════════════════════════════════════════════════
Generate 5–8 internal linking suggestions.
For each:
  anchorText  → the exact text to hyperlink
  targetUrl   → suggested relative URL (e.g. /category/related-post)
  placement   → section heading where the link should appear
  reason      → one sentence explaining the topical relevance

═══════════════════════════════════════════════════════════════════════════════
RULE 11 — EXTERNAL LINKS
═══════════════════════════════════════════════════════════════════════════════
Generate 5–10 external authority links.
• Every link MUST come from Tavily search results.
• Never fabricate URLs.
For each:
  title      → full title of the linked page
  publisher  → name of the publishing organisation
  url        → full original URL (clickable Markdown link)
  reasonUsed → one sentence explaining why this link adds value

═══════════════════════════════════════════════════════════════════════════════
RULE 12 — CONTENT FLOW
═══════════════════════════════════════════════════════════════════════════════
Strictly follow this micro-structure within the article:

  Introduction → TOC → Hero Image → H2 → Paragraph → List → Image →
  H2 → Table → Paragraph → Image → Expert Tip → H2 → Comparison →
  Image → Conclusion → References → FAQ → JSON-LD Schema

Deviate only when the Layout Plan explicitly specifies otherwise.

═══════════════════════════════════════════════════════════════════════════════
RULE 13 — POST-WRITING VALIDATION LOOP (max 3 iterations)
═══════════════════════════════════════════════════════════════════════════════
After generating the full article, evaluate EVERY item below.
If ANY item fails, REWRITE ONLY the failed section (not the whole article).
Repeat until all pass or 3 iterations are reached.

Checklist:
  [ ] Word Count: 1800–3000 total words
  [ ] No paragraph exceeds 60 words
  [ ] No paragraph is fewer than 30 words
  [ ] One image after the title (Hero)
  [ ] One image every 300–500 words thereafter
  [ ] No two consecutive images
  [ ] Heading hierarchy correct (H1 → H2 → H3 → H4, no skips)
  [ ] References: all URLs from Tavily, no fabricated links
  [ ] FAQ appears AFTER References
  [ ] JSON-LD Schema appears AFTER FAQ
  [ ] Keyword density 0.8%–1.8%
  [ ] Primary keyword in first 100 words
  [ ] Meta title 50–60 chars
  [ ] Meta description 150–160 chars
  [ ] Transition words in at least 30% of sentences
  [ ] No AI clichés present
  [ ] Passive voice in no more than 10% of sentences
  [ ] Every factual claim backed by Evidence Library
  [ ] unsupportedClaimsFlag = false

═══════════════════════════════════════════════════════════════════════════════
Return ONLY a JSON object matching this EXACT schema — no markdown fences:
═══════════════════════════════════════════════════════════════════════════════
{
  "seoChecklist": {
    "primaryKeyword": "string",
    "secondaryKeywords": ["string"],
    "slug": "string",
    "metaTitle": "string (50–60 chars)",
    "metaDescription": "string (150–160 chars)",
    "keywordDensityTarget": "string",
    "targetWordCount": "integer"
  },
  "title": "string (H1)",
  "introduction": "string (Markdown, 150–250 words, primary keyword in first sentence)",
  "tableOfContents": ["string (all H2 and H3 headings in order)"],
  "sections": [
    {
      "id": "string (matches Layout Plan section id)",
      "heading": "string",
      "headingLevel": "integer (1–4)",
      "content": "string (Markdown — paragraphs, lists, tables, callouts all inline)",
      "callout": {
        "type": "string or null",
        "content": "string or null"
      },
      "table": {
        "included": "boolean",
        "markdownTable": "string or null"
      },
      "citationsUsed": ["string (Source IDs from Evidence Library)"]
    }
  ],
  "imageInstructions": [
    {
      "index": "integer (1-based)",
      "placement": "string",
      "prompt": "string (FLUX-compatible generation prompt)",
      "altText": "string (contains primary keyword)",
      "caption": "string",
      "description": "string (LSI/semantic keywords)"
    }
  ],
  "conclusion": "string (Markdown, 150–250 words)",
  "references": [
    {
      "index": "integer",
      "title": "string",
      "publisher": "string",
      "author": "string",
      "publishedDate": "string",
      "url": "string (full original Tavily URL)",
      "reasonUsed": "string"
    }
  ],
  "faqs": [
    {
      "question": "string",
      "answer": "string (Markdown, 40–80 words)"
    }
  ],
  "jsonLdSchema": "string (valid JSON-LD — Article + FAQPage combined)",
  "internalLinks": [
    {
      "anchorText": "string",
      "targetUrl": "string (relative URL)",
      "placement": "string (section heading)",
      "reason": "string"
    }
  ],
  "externalLinks": [
    {
      "title": "string",
      "publisher": "string",
      "url": "string (full original Tavily URL)",
      "reasonUsed": "string"
    }
  ],
  "validationReport": {
    "wordCount": "integer",
    "keywordDensity": "string",
    "totalImages": "integer",
    "totalInternalLinks": "integer",
    "totalExternalLinks": "integer",
    "totalFaqs": "integer",
    "iterationsRequired": "integer (1–3)",
    "failedChecks": ["string"],
    "allChecksPassed": "boolean"
  },
  "unsupportedClaimsFlag": "boolean (true ONLY if a section could not be written from Evidence Library alone)"
}
''';
}
