import 'package:flutter_test/flutter_test.dart';
import 'package:llanguage/core/secure_storage/in_memory_secure_storage_service.dart';
import 'package:llanguage/core/secure_storage/secure_storage_service.dart';

void main() {
  late SecureStorageService storage;

  setUp(() {
    storage = InMemorySecureStorageService();
  });

  group('saveApiKey / getApiKey', () {
    test('saves and retrieves an API key', () async {
      await storage.saveApiKey('OpenRouter', 'sk-or-123');
      final result = await storage.getApiKey('OpenRouter');
      expect(result, equals('sk-or-123'));
    });

    test('returns null for unsaved key', () async {
      final result = await storage.getApiKey('Nonexistent');
      expect(result, isNull);
    });

    test('overwrites existing key', () async {
      await storage.saveApiKey('Groq', 'old-key');
      await storage.saveApiKey('Groq', 'new-key');
      final result = await storage.getApiKey('Groq');
      expect(result, equals('new-key'));
    });
  });

  group('hasApiKey', () {
    test('returns true when key exists', () async {
      await storage.saveApiKey('xAI', 'sk-xai-1');
      expect(await storage.hasApiKey('xAI'), isTrue);
    });

    test('returns false when key does not exist', () async {
      expect(await storage.hasApiKey('nope'), isFalse);
    });

    test('returns false after delete', () async {
      await storage.saveApiKey('DeepSeek', 'sk-ds-1');
      await storage.deleteApiKey('DeepSeek');
      expect(await storage.hasApiKey('DeepSeek'), isFalse);
    });
  });

  group('deleteApiKey', () {
    test('removes a saved key', () async {
      await storage.saveApiKey('Ollama', 'ollama-key');
      await storage.deleteApiKey('Ollama');
      expect(await storage.getApiKey('Ollama'), isNull);
    });

    test('does not throw when deleting nonexistent key', () async {
      await storage.deleteApiKey('ghost');
    });
  });

  group('clearAll', () {
    test('clears all stored keys', () async {
      await storage.saveApiKey('A', 'a');
      await storage.saveApiKey('B', 'b');
      await storage.clearAll();
      expect(await storage.getApiKey('A'), isNull);
      expect(await storage.getApiKey('B'), isNull);
    });
  });
}
