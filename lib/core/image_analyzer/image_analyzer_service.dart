import 'dart:convert';
import '../ai/models/ai_request.dart';
import '../ai/providers/ai_provider.dart';
import 'models/image_analysis_result.dart';

class ImageAnalyzerService {
  final AiProvider _aiProvider;
  final String _apiKey;

  ImageAnalyzerService({
    required AiProvider aiProvider,
    required String apiKey,
  })  : _aiProvider = aiProvider,
        _apiKey = apiKey;

  Future<ImageAnalysisResult> analyze(String imageUrl) async {
    final messages = [
      AiMessage(
        role: 'user',
        content: 'Describe this image in detail. Identify all objects visible. '
            'Respond with JSON: {"label": "main subject (one word in English)", '
            '"description": "brief description", '
            '"objects": [{"name": "object name in English", "confidence": 0.95}]}',
        imageUrls: [imageUrl],
      ),
    ];

    final request = AiRequest(model: _aiProvider.defaultModel, messages: messages);
    final response = await _aiProvider.chat(request, apiKey: _apiKey);
    final body = response.content;

    Map<String, dynamic> json;
    try {
      json = _extractJson(body);
    } catch (_) {
      json = {'label': '', 'description': body};
    }

    return ImageAnalysisResult(
      label: json['label'] as String? ?? '',
      description: json['description'] as String? ?? body,
      objects: (json['objects'] as List<dynamic>?)
              ?.map((e) => DetectedObject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> _extractJson(String body) {
    final start = body.indexOf('{');
    final end = body.lastIndexOf('}');
    if (start == -1 || end == -1) throw FormatException('No JSON found');
    return jsonDecode(body.substring(start, end + 1)) as Map<String, dynamic>;
  }
}
