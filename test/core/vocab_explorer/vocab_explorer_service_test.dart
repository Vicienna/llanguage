import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:llanguage/core/ai/models/ai_request.dart';
import 'package:llanguage/core/ai/models/ai_response.dart';
import 'package:llanguage/core/ai/providers/ai_provider.dart';
import 'package:llanguage/core/duckduckgo/duckduckgo_result.dart';
import 'package:llanguage/core/duckduckgo/duckduckgo_service.dart';
import 'package:llanguage/core/vocab_explorer/vocab_explorer_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAiProvider extends Mock implements AiProvider {}
class MockDuckDuckGoService extends Mock implements DuckDuckGoService {}

void main() {
  late MockAiProvider aiProvider;
  late MockDuckDuckGoService ddgService;
  late VocabExplorerService service;

  setUpAll(() {
    registerFallbackValue(AiRequest(model: '', messages: []));
    registerFallbackValue(Uri());
  });

  setUp(() {
    aiProvider = MockAiProvider();
    ddgService = MockDuckDuckGoService();
    when(() => aiProvider.defaultModel).thenReturn('test-model');
    service = VocabExplorerService(
      aiProvider: aiProvider,
      ddgService: ddgService,
      apiKey: 'test-key',
    );
  });

  group('findRelated', () {
    test('returns related words from DuckDuckGo', () async {
      when(() => ddgService.instantAnswer('dog')).thenAnswer(
        (_) async => DdgResult(
          query: 'dog',
          abstractText: 'A domesticated carnivorous mammal.',
          relatedTopics: [
            DdgRelatedTopic(text: 'Wolf related to dogs'),
            DdgRelatedTopic(text: 'Canine family includes dogs'),
          ],
        ),
      );
      when(() => aiProvider.chat(any(), apiKey: any(named: 'apiKey')))
          .thenAnswer((_) async => AiResponse(
            content: jsonEncode({
              'related': [
                {'word': 'wolf', 'relation': 'related'},
                {'word': 'canine', 'relation': 'related'},
              ],
            }),
            model: 'test-model',
          ));

      final related = await service.findRelated('dog');

      expect(related.length, greaterThanOrEqualTo(2));
      expect(related.any((r) => r.word == 'Wolf'), isTrue);
      expect(related.any((r) => r.word == 'Canine'), isTrue);
    });

    test('handles empty DuckDuckGo results', () async {
      when(() => ddgService.instantAnswer('xyzzy')).thenAnswer(
        (_) async => DdgResult(
          query: 'xyzzy',
          relatedTopics: [],
        ),
      );
      when(() => aiProvider.chat(any(), apiKey: any(named: 'apiKey')))
          .thenAnswer((_) async => AiResponse(
            content: jsonEncode({'related': []}),
            model: 'test-model',
          ));

      final related = await service.findRelated('xyzzy');
      expect(related, isEmpty);
    });
  });
}
