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

    test('toJson includes imageUrls when present', () {
      final msg = AiMessage(
        role: 'user',
        content: 'Describe this',
        imageUrls: ['https://example.com/img.jpg'],
      );
      final json = msg.toJson();
      final content = json['content'] as List;
      expect(content.length, equals(2));
      expect(content[0]['type'], equals('text'));
      expect(content[1]['type'], equals('image_url'));
      expect(content[1]['image_url']['url'], equals('https://example.com/img.jpg'));
    });

    test('toJson omits imageUrls when empty', () {
      final msg = AiMessage(role: 'user', content: 'Hello');
      final json = msg.toJson();
      expect(json['content'], isA<String>());
    });

    test('fromJson parses multi-part content', () {
      final json = {
        'role': 'user',
        'content': [
          {'type': 'text', 'text': 'Describe'},
          {'type': 'image_url', 'image_url': {'url': 'data:image/png;base64,abc'}},
        ],
      };
      final msg = AiMessage.fromJson(json);
      expect(msg.content, equals('Describe'));
      expect(msg.imageUrls, contains('data:image/png;base64,abc'));
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
