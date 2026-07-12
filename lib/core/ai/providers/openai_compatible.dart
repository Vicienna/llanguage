import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_request.dart';
import '../models/ai_response.dart';
import 'ai_provider.dart';

class OpenAiCompatible extends AiProvider {
  @override
  final String name;
  @override
  final String baseUrl;
  @override
  final String defaultModel;
  @override
  final bool apiKeyRequired;

  final http.Client _client;

  OpenAiCompatible({
    required this.name,
    required this.baseUrl,
    required this.defaultModel,
    this.apiKeyRequired = true,
    http.Client? client,
  }) : _client = client ?? http.Client();

  @override
  Future<AiResponse> chat(AiRequest request, {required String apiKey}) async {
    final uri = Uri.parse('$baseUrl/v1/chat/completions');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (apiKeyRequired) 'Authorization': 'Bearer $apiKey',
    };
    final body = jsonEncode(request.toJson());

    final response = await _client.post(uri, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw AiProviderException(
        'API error: ${response.statusCode} ${response.body}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return AiResponse.fromJson(json);
  }

  @override
  bool supportsStreaming() => true;

  void dispose() => _client.close();
}

class AiProviderException implements Exception {
  final String message;
  const AiProviderException(this.message);

  @override
  String toString() => 'AiProviderException: $message';
}
