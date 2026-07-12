import 'dart:convert';
import 'package:http/http.dart' as http;
import 'duckduckgo_result.dart';

class DuckDuckGoService {
  final http.Client _client;
  static const _baseUrl = 'https://api.duckduckgo.com';

  DuckDuckGoService({http.Client? client}) : _client = client ?? http.Client();

  Future<DdgResult> instantAnswer(String query) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'q': query,
      'format': 'json',
      'no_html': '1',
      'skip_disambig': '1',
    });
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw DdgException('DuckDuckGo API error: ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return DdgResult.fromJson(query, json);
  }

  void dispose() => _client.close();
}

class DdgException implements Exception {
  final String message;
  const DdgException(this.message);
  @override
  String toString() => 'DdgException: $message';
}
