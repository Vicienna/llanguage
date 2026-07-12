import 'package:flutter_test/flutter_test.dart';
import 'package:llanguage/core/ai/models/ai_request.dart';
import 'package:llanguage/core/ai/models/ai_response.dart';
import 'package:llanguage/core/ai/providers/ai_provider.dart';
import 'package:llanguage/core/duckduckgo/duckduckgo_service.dart';
import 'package:llanguage/core/flashcard/flashcard_generator.dart';
import 'package:llanguage/core/image_analyzer/image_analyzer_service.dart';
import 'package:llanguage/core/translation/translation_cache.dart';
import 'package:llanguage/core/translation/translation_service.dart';
import 'package:mocktail/mocktail.dart';
import '../fakes/fake_cache_dao.dart';

class MockAiProvider extends Mock implements AiProvider {}
class MockDuckDuckGoService extends Mock implements DuckDuckGoService {}

void main() {
  late MockAiProvider aiProvider;
  late MockDuckDuckGoService ddgService;
  late FakeCacheDao cacheDao;
  late TranslationService translationService;
  late ImageAnalyzerService imageAnalyzer;
  late FlashcardGenerator generator;

  setUpAll(() {
    registerFallbackValue(AiRequest(model: '', messages: []));
    registerFallbackValue(Uri());
  });

  setUp(() {
    aiProvider = MockAiProvider();
    ddgService = MockDuckDuckGoService();
    cacheDao = FakeCacheDao();

    when(() => aiProvider.defaultModel).thenReturn('test-model');

    translationService = TranslationService(
      aiProvider: aiProvider,
      ddgService: ddgService,
      cache: TranslationCache(cacheDao),
      apiKey: 'test-key',
    );

    imageAnalyzer = ImageAnalyzerService(
      aiProvider: aiProvider,
      apiKey: 'test-key',
    );

    generator = FlashcardGenerator(
      translationService: translationService,
      imageAnalyzer: imageAnalyzer,
    );
  });

  group('generateFromImage', () {
    test('creates flashcard from image analysis', () async {
      when(() => aiProvider.chat(any(), apiKey: any(named: 'apiKey')))
          .thenAnswer((_) async => AiResponse(
            content: '{"label": "cat", "description": "A cat", "objects": []}',
            model: 'test-model',
          ));

      when(() => ddgService.instantAnswer(any())).thenThrow(DdgException('fail'));

      final flashcard = await generator.generateFromImage(
        'https://example.com/cat.jpg',
        'id',
      );

      expect(flashcard.word, equals('cat'));
      expect(flashcard.imageUrl, equals('https://example.com/cat.jpg'));
      expect(flashcard.definition, equals('A cat'));
    });
  });

  group('generateFromText', () {
    test('creates flashcard from text translation', () async {
      when(() => aiProvider.chat(any(), apiKey: any(named: 'apiKey')))
          .thenAnswer((_) async => AiResponse(
            content: '{"translated_text": "kucing", "detected_source_lang": "en"}',
            model: 'test-model',
          ));

      when(() => ddgService.instantAnswer(any())).thenThrow(DdgException('fail'));

      final flashcard = await generator.generateFromText('cat', 'id');

      expect(flashcard.word, equals('cat'));
      expect(flashcard.translation, equals('kucing'));
    });
  });
}
