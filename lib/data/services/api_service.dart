import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ⚠️ SECURITY WARNING: This key is public.
  // You should regenerate a new one and store it securely
  // (e.g., using --dart-define), not in your source code.
  final String _apiKey = "2eed7486420124091d6cb414"; // <-- Step 1: Replace this

  // Step 2: Fix the base URL. It should ONLY be the base.
  final String _baseUrl = "https://v6.exchangerate-api.com/v6/";

  // Fetches the latest rates for a base currency
  Future<Map<String, dynamic>> getExchangeRates(String baseCurrency) async {
    // Step 3: Fix the URL construction.
    // This now correctly builds: BASE_URL + API_KEY + /latest/ + CURRENCY
    final String url = "$_baseUrl$_apiKey/latest/$baseCurrency";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Success
        final data = json.decode(response.body);
        if (data['result'] == 'success') {
          return data['conversion_rates'];
        } else {
          throw Exception('API Error: ${data['error-type']}');
        }
      } else {
        // Server error
        throw Exception('Failed to load exchange rates: ${response.statusCode}');
      }
    } catch (e) {
      // Network or other error
      throw Exception('Failed to connect: $e');
    }
  }
}