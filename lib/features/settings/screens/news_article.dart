class NewsArticle {
  final String title;
  final String summary;
  final String url;
  final String imageUrl;
  final DateTime publishedAt;

  NewsArticle({
    required this.title,
    required this.summary,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      summary: json['description'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      publishedAt: DateTime.parse(json['publishedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
