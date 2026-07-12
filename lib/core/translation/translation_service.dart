import 'dart:convert';
import '../ai/models/ai_request.dart';
import '../ai/providers/ai_provider.dart';
import '../duckduckgo/duckduckgo_result.dart';
import '../duckduckgo/duckduckgo_service.dart';
import 'models/translation_request.dart';
import 'models/translation_result.dart';
import 'translation_cache.dart';

class TranslationService {
  final AiProvider _aiProvider;
  final DuckDuckGoService _ddgService;
  final TranslationCache _cache;
  final String _apiKey;

  TranslationService({
    required AiProvider aiProvider,
    required DuckDuckGoService ddgService,
    required TranslationCache cache,
    required String apiKey,
  })  : _aiProvider = aiProvider,
        _ddgService = ddgService,
        _cache = cache,
        _apiKey = apiKey;

  Future<TranslationResult> translate(TranslationRequest request) async {
    final cached = await _cache.get(request);
    if (cached != null) return cached;

    final messages = [
      AiMessage(
        role: 'system',
        content:
            'You are a translator. Translate the following text from ${request.sourceLang} to ${request.targetLang}. '
            'Respond with JSON: {"translated_text": "...", "detected_source_lang": "...", '
            '"word_breakdown": [{"word": "...", "translation": "..."}], "definitions": []}',
      ),
      AiMessage(role: 'user', content: request.text),
    ];

    final aiRequest = AiRequest(model: _aiProvider.defaultModel, messages: messages);
    final aiResponse = await _aiProvider.chat(aiRequest, apiKey: _apiKey);

    final body = aiResponse.content;

    Map<String, dynamic> json;
    try {
      json = _extractJson(body);
    } catch (_) {
      json = {
        'translated_text': body,
        'source_text': request.text,
        'detected_source_lang': request.sourceLang,
        'target_lang': request.targetLang,
      };
    }

    final result = TranslationResult(
      translatedText: json['translated_text'] as String? ?? body,
      sourceText: request.text,
      detectedSourceLang: json['detected_source_lang'] as String? ?? request.sourceLang,
      targetLang: request.targetLang,
      wordBreakdown: (json['word_breakdown'] as List<dynamic>?)
              ?.map((e) => WordBreakdown.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      definitions: (json['definitions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

    try {
      final ddgResult = await _ddgService.instantAnswer(request.text);
      final enriched = _enrichWithDdg(result, ddgResult);
      await _cache.set(request, enriched);
      return enriched;
    } catch (_) {
      await _cache.set(request, result);
      return result;
    }
  }

  TranslationResult _enrichWithDdg(TranslationResult result, DdgResult ddg) {
    final definitions = result.definitions.toList();
    if (ddg.abstractText != null && !definitions.contains(ddg.abstractText)) {
      definitions.add(ddg.abstractText!);
    }
    if (ddg.definition != null && ddg.definition!.isNotEmpty && !definitions.contains(ddg.definition)) {
      definitions.add(ddg.definition!);
    }
    return TranslationResult(
      translatedText: result.translatedText,
      sourceText: result.sourceText,
      detectedSourceLang: result.detectedSourceLang,
      targetLang: result.targetLang,
      wordBreakdown: result.wordBreakdown,
      definitions: definitions,
    );
  }

  Map<String, dynamic> _extractJson(String body) {
    final start = body.indexOf('{');
    final end = body.lastIndexOf('}');
    if (start == -1 || end == -1) throw FormatException('No JSON found');
    final jsonStr = body.substring(start, end + 1);
    return jsonDecode(jsonStr) as Map<String, dynamic>;
  }
}
