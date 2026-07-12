import '../models/ai_request.dart';
import '../models/ai_response.dart';

abstract class AiProvider {
  String get name;
  String get baseUrl;
  String get defaultModel;
  bool get apiKeyRequired;

  Future<AiResponse> chat(AiRequest request, {required String apiKey});
  bool supportsStreaming() => false;
}
