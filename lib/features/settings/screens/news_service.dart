import 'dart:convert';
import 'package:http/http.dart' as http;
import 'news_article.dart';

class NewsService {
  final String apiKey = '69762927a7294a618c9d71f206380d2a';

  Future<List<NewsArticle>> fetchNews({
    required String query,
    String fromDate = '',
    String sortBy = 'publishedAt',
    int pageSize = 10,
  }) async {
    final Map<String, String> queryParams = {
      'q': query,
      'pageSize': pageSize.toString(),
      'sortBy': sortBy,
      'apiKey': apiKey,
    };

    // Only include 'from' if it's provided
    if (fromDate.isNotEmpty) {
      queryParams['from'] = fromDate;
    }

    final url = Uri.https('newsapi.org', '/v2/everything', queryParams);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List items = data['articles'] ?? [];
      return items.map((item) => NewsArticle.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load news: ${response.statusCode}');
    }
  }
}
