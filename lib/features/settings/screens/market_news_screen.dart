import 'package:flutter/material.dart';
import 'news_article.dart';
import 'news_service.dart';

class MarketNewsScreen extends StatefulWidget {
  const MarketNewsScreen({super.key});

  @override
  State<MarketNewsScreen> createState() => _MarketNewsScreenState();
}

class _MarketNewsScreenState extends State<MarketNewsScreen> {
  final NewsService _newsService = NewsService();
  late Future<List<NewsArticle>> _futureNews;

  @override
  void initState() {
    super.initState();
    // Call the correct method fetchNews instead of fetchMarketNews
    _futureNews = _newsService.fetchNews(
      query: 'forex OR crypto OR currency markets',
      fromDate: '2025-10-12', // optional: adjust the date
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Market News")),
      body: FutureBuilder<List<NewsArticle>>(
        future: _futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final articles = snapshot.data!;
          if (articles.isEmpty) {
            return const Center(child: Text('No news found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: articles.length,
            itemBuilder: (context, i) {
              final item = articles[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        child: Image.network(
                          item.imageUrl,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.summary,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: theme.hintColor),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Published: ${item.publishedAt.toLocal().toString().split(' ')[0]}",
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // TODO: Open item.url in browser or WebView
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Text(
                          "Read full article",
                          style:
                          TextStyle(color: theme.colorScheme.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
