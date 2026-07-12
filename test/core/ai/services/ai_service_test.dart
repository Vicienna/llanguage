import 'package:flutter_test/flutter_test.dart';
import 'package:llanguage/core/ai/services/ai_service.dart';
import 'package:llanguage/core/ai/providers/openai_compatible.dart';

void main() {
  late AiService service;

  setUp(() {
    service = AiService();
  });

  group('AiService', () {
    test('loadPresets adds all providers', () {
      service.loadPresets();
      expect(service.allProviders.length, equals(5));
      expect(service.allProviders.map((p) => p.name), contains('OpenRouter'));
      expect(service.allProviders.map((p) => p.name), contains('Ollama'));
    });

    test('registerProvider and setActiveProvider', () {
      final provider = OpenAiCompatible(
        name: 'Custom',
        baseUrl: 'https://custom.api.com',
        defaultModel: 'custom-model',
      );
      service.registerProvider(provider);
      service.setActiveProvider('Custom');
      expect(service.activeProvider!.name, equals('Custom'));
    });

    test('setActiveProvider throws for unknown provider', () {
      expect(
        () => service.setActiveProvider('nonexistent'),
        throwsArgumentError,
      );
    });

    test('addCustomProvider adds a custom provider', () {
      service.addCustomProvider(
        name: 'My Provider',
        baseUrl: 'https://my.provider.com',
        defaultModel: 'my-model',
      );
      expect(service.allProviders.length, equals(1));
      expect(service.allProviders.first.apiKeyRequired, isTrue);
    });

    test('Ollama preset has apiKeyRequired false', () {
      service.loadPresets();
      final ollama = service.allProviders.firstWhere((p) => p.name == 'Ollama');
      expect(ollama.apiKeyRequired, isFalse);
    });
  });
}
