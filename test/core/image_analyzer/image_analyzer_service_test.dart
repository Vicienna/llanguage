import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:llanguage/core/ai/models/ai_request.dart';
import 'package:llanguage/core/ai/models/ai_response.dart';
import 'package:llanguage/core/ai/providers/ai_provider.dart';
import 'package:llanguage/core/image_analyzer/image_analyzer_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAiProvider extends Mock implements AiProvider {}

void main() {
  late MockAiProvider aiProvider;
  late ImageAnalyzerService service;

  setUpAll(() {
    registerFallbackValue(AiRequest(model: '', messages: []));
  });

  setUp(() {
    aiProvider = MockAiProvider();
    when(() => aiProvider.defaultModel).thenReturn('vision-model');
    service = ImageAnalyzerService(aiProvider: aiProvider, apiKey: 'test-key');
  });

  group('analyze', () {
    test('returns parsed result on JSON response', () async {
      when(() => aiProvider.chat(any(), apiKey: any(named: 'apiKey'))).thenAnswer(
        (_) async => AiResponse(
          content: jsonEncode({
            'label': 'cat',
            'description': 'A cute cat',
            'objects': [
              {'name': 'cat', 'confidence': 0.99},
            ],
          }),
          model: 'vision-model',
        ),
      );

      final result = await service.analyze('https://example.com/cat.jpg');

      expect(result.label, equals('cat'));
      expect(result.description, equals('A cute cat'));
      expect(result.objects.length, equals(1));
      expect(result.objects[0].name, equals('cat'));

      final captured = verify(() => aiProvider.chat(captureAny(), apiKey: 'test-key'))
          .captured
          .first as AiRequest;
      expect(captured.messages.first.imageUrls, contains('https://example.com/cat.jpg'));
    });

    test('falls back to raw content on non-JSON response', () async {
      when(() => aiProvider.chat(any(), apiKey: any(named: 'apiKey'))).thenAnswer(
        (_) async => AiResponse(
          content: 'A dog playing in the park',
          model: 'vision-model',
        ),
      );

      final result = await service.analyze('https://example.com/dog.jpg');

      expect(result.description, equals('A dog playing in the park'));
      expect(result.label, isEmpty);
      expect(result.objects, isEmpty);
    });
  });
}
