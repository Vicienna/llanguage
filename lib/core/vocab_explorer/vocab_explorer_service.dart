import 'dart:convert';
import '../ai/models/ai_request.dart';
import '../ai/providers/ai_provider.dart';
import '../duckduckgo/duckduckgo_service.dart';

class RelatedVocab {
  final String word;
  final String relation;

  const RelatedVocab({required this.word, required this.relation});
}

class VocabExplorerService {
  final AiProvider _aiProvider;
  final DuckDuckGoService _ddgService;
  final String _apiKey;

  VocabExplorerService({
    required AiProvider aiProvider,
    required DuckDuckGoService ddgService,
    required String apiKey,
  })  : _aiProvider = aiProvider,
        _ddgService = ddgService,
        _apiKey = apiKey;

  Future<List<RelatedVocab>> findRelated(String word) async {
    final ddgResult = await _ddgService.instantAnswer(word);
    final related = <RelatedVocab>{};

    for (final topic in ddgResult.relatedTopics) {
      if (topic.text != null) {
        final firstWord = topic.text!.split(RegExp(r'\s+')).first;
        if (firstWord.length >= 2) {
          related.add(RelatedVocab(word: firstWord, relation: 'related'));
        }
      }
    }

    if (ddgResult.abstractText != null) {
      final aiRelated = await _findRelatedViaAi(word);
      related.addAll(aiRelated);
    }

    return related.take(10).toList();
  }

  Future<List<RelatedVocab>> _findRelatedViaAi(String word) async {
    final messages = [
      AiMessage(
        role: 'system',
        content: 'List 5 words related to "$word" in English. '
            'Respond with JSON: {"related": [{"word": "...", "relation": "synonym/antonym/related"}]}',
      ),
      AiMessage(role: 'user', content: 'Find related words for: $word'),
    ];

    final request = AiRequest(model: _aiProvider.defaultModel, messages: messages);
    final response = await _aiProvider.chat(request, apiKey: _apiKey);

    try {
      final json = _extractJson(response.content);
      final list = json['related'] as List<dynamic>;
      return list
          .map((e) {
            final m = e as Map<String, dynamic>;
            return RelatedVocab(
              word: m['word'] as String,
              relation: m['relation'] as String? ?? 'related',
            );
          })
          .toList();
    } catch (_) {
      return [];
    }
  }

  Map<String, dynamic> _extractJson(String body) {
    final start = body.indexOf('{');
    final end = body.lastIndexOf('}');
    if (start == -1 || end == -1) throw FormatException('No JSON found');
    return jsonDecode(body.substring(start, end + 1)) as Map<String, dynamic>;
  }
}
