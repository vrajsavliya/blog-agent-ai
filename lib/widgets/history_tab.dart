import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/article_model.dart';
import '../services/firestore_service.dart';
import '../screens/article_preview_screen.dart';
import 'reusable_widgets.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Article>>(
      stream: FirestoreService().getArticles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: kAccent),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading history.\n${snapshot.error}',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: kRed),
            ),
          );
        }

        final articles = snapshot.data ?? [];

        if (articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history_edu_rounded, size: 48, color: kTextSecondary.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                Text(
                  'No articles generated yet.',
                  style: GoogleFonts.inter(
                    color: kTextSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return _ArticleCard(article: article);
            },
          ),
        );
      },
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final Article article;

  const _ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    final dateStr = article.createdAt.toLocal().toString().split(' ')[0];
    final isPublished = article.status == PublishStatus.published;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ArticlePreviewScreen(article: article),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.content.title.isEmpty ? article.topic.title : article.content.title,
                        style: GoogleFonts.inter(
                          color: kTextPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 14, color: kTextSecondary),
                          const SizedBox(width: 4),
                          Text(
                            dateStr,
                            style: GoogleFonts.inter(
                              color: kTextSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isPublished ? Colors.green.withValues(alpha: 0.1) : kOrange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isPublished ? 'Published' : 'Draft',
                              style: GoogleFonts.inter(
                                color: isPublished ? Colors.green : kOrange,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: kRed, size: 20),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: kCardBg,
                        title: Text('Delete Article?', style: GoogleFonts.inter(color: kTextPrimary)),
                        content: Text('Are you sure you want to delete this article? This cannot be undone.', style: GoogleFonts.inter(color: kTextSecondary)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Cancel', style: GoogleFonts.inter(color: kTextSecondary)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('Delete', style: GoogleFonts.inter(color: kRed)),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true && article.id != null) {
                      await FirestoreService().deleteArticle(article.id!);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
