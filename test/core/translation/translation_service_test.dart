import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:llanguage/core/ai/models/ai_request.dart';
import 'package:llanguage/core/ai/models/ai_response.dart';
import 'package:llanguage/core/ai/providers/ai_provider.dart';
import 'package:llanguage/core/duckduckgo/duckduckgo_result.dart';
import 'package:llanguage/core/duckduckgo/duckduckgo_service.dart';
import 'package:llanguage/core/translation/translation_cache.dart';
import 'package:llanguage/core/translation/models/translation_request.dart';
import 'package:llanguage/core/translation/models/translation_result.dart';
import 'package:llanguage/core/translation/translation_service.dart';
import 'package:mocktail/mocktail.dart';
import '../fakes/fake_cache_dao.dart';

class MockAiProvider extends Mock implements AiProvider {}
class MockDuckDuckGoService extends Mock implements DuckDuckGoService {}

void main() {
  late MockAiProvider aiProvider;
  late MockDuckDuckGoService ddgService;
  late FakeCacheDao cacheDao;
  late TranslationService service;

  setUpAll(() {
    registerFallbackValue(AiRequest(model: '', messages: []));
    registerFallbackValue(Uri());
  });

  setUp(() {
    aiProvider = MockAiProvider();
    ddgService = MockDuckDuckGoService();
    cacheDao = FakeCacheDao();

    when(() => aiProvider.defaultModel).thenReturn('test-model');

    service = TranslationService(
      aiProvider: aiProvider,
      ddgService: ddgService,
      cache: TranslationCache(cacheDao),
      apiKey: 'test-key',
    );
  });

  group('translate', () {
    test('returns cached result without calling AI', () async {
      cacheDao.setCache(
        cacheKey: 'trans:hello:auto:id',
        prompt: '',
        response: jsonEncode({
          'translated_text': 'halo',
          'source_text': 'hello',
          'detected_source_lang': 'en',
          'target_lang': 'id',
          'word_breakdown': [],
          'definitions': [],
        }),
        model: '',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now(),
      );

      final result = await service.translate(
        TranslationRequest(text: 'hello', targetLang: 'id'),
      );

      expect(result.translatedText, equals('halo'));
      verifyNever(() => aiProvider.chat(any(), apiKey: any(named: 'apiKey')));
    });

    test('translates via AI when not cached', () async {
      when(() => aiProvider.chat(any(), apiKey: any(named: 'apiKey'))).thenAnswer(
        (_) async => AiResponse(
          content: jsonEncode({
            'translated_text': 'halo',
            'detected_source_lang': 'en',
          }),
          model: 'test-model',
        ),
      );
      when(() => ddgService.instantAnswer(any())).thenThrow(DdgException('fail'));

      final result = await service.translate(
        TranslationRequest(text: 'hello', targetLang: 'id'),
      );

      expect(result.translatedText, equals('halo'));
      expect(result.detectedSourceLang, equals('en'));
      verify(() => aiProvider.chat(any(), apiKey: 'test-key')).called(1);
    });

    test('enriches with DuckDuckGo definitions', () async {
      when(() => aiProvider.chat(any(), apiKey: any(named: 'apiKey'))).thenAnswer(
        (_) async => AiResponse(
          content: jsonEncode({
            'translated_text': 'halo',
            'detected_source_lang': 'en',
          }),
          model: 'test-model',
        ),
      );
      when(() => ddgService.instantAnswer(any())).thenAnswer(
        (_) async => DdgResult(
          query: 'hello',
          abstractText: 'A greeting',
          relatedTopics: [],
        ),
      );

      final result = await service.translate(
        TranslationRequest(text: 'hello', targetLang: 'id'),
      );

      expect(result.translatedText, equals('halo'));
      expect(result.definitions, contains('A greeting'));
    });

    test('falls back to raw content when AI returns non-JSON', () async {
      when(() => aiProvider.chat(any(), apiKey: any(named: 'apiKey'))).thenAnswer(
        (_) async => AiResponse(
          content: 'halo',
          model: 'test-model',
        ),
      );
      when(() => ddgService.instantAnswer(any())).thenThrow(DdgException('fail'));

      final result = await service.translate(
        TranslationRequest(text: 'hello', targetLang: 'id'),
      );

      expect(result.translatedText, equals('halo'));
    });
  });
}
