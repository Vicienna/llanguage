import 'package:flutter_test/flutter_test.dart';
import 'package:llanguage/core/ai/models/ai_request.dart';

void main() {
  group('AiMessage', () {
    test('toJson produces correct map', () {
      final msg = AiMessage(role: 'user', content: 'Hello');
      expect(msg.toJson(), equals({'role': 'user', 'content': 'Hello'}));
    });

    test('fromJson parses correctly', () {
      final msg = AiMessage.fromJson({'role': 'assistant', 'content': 'Hi'});
      expect(msg.role, equals('assistant'));
      expect(msg.content, equals('Hi'));
    });
  });

  group('AiRequest', () {
    test('toJson produces correct map', () {
      final req = AiRequest(
        model: 'gpt-4',
        messages: [AiMessage(role: 'user', content: 'Hello')],
        temperature: 0.5,
        maxTokens: 512,
      );
      final json = req.toJson();
      expect(json['model'], equals('gpt-4'));
      expect(json['temperature'], equals(0.5));
      expect(json['max_tokens'], equals(512));
      expect((json['messages'] as List).length, equals(1));
    });

    test('uses default values', () {
      final req = AiRequest(
        model: 'gpt-4',
        messages: [AiMessage(role: 'user', content: 'Hi')],
      );
      expect(req.temperature, equals(0.7));
      expect(req.maxTokens, equals(1024));
    });
  });
}
