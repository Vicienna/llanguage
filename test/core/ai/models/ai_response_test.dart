import 'package:flutter_test/flutter_test.dart';
import 'package:llanguage/core/ai/models/ai_response.dart';

void main() {
  group('AiResponse', () {
    test('fromJson parses OpenAI response', () {
      final json = {
        'id': 'chatcmpl-123',
        'object': 'chat.completion',
        'created': 1677652288,
        'model': 'gpt-4',
        'choices': [
          {
            'index': 0,
            'message': {'role': 'assistant', 'content': 'Hello there!'},
            'finish_reason': 'stop',
          },
        ],
        'usage': {'prompt_tokens': 10, 'completion_tokens': 3},
      };
      final response = AiResponse.fromJson(json);
      expect(response.content, equals('Hello there!'));
      expect(response.model, equals('gpt-4'));
      expect(response.usage!.promptTokens, equals(10));
      expect(response.usage!.completionTokens, equals(3));
    });

    test('fromJson handles missing usage', () {
      final json = {
        'model': 'gpt-4',
        'choices': [
          {
            'message': {'role': 'assistant', 'content': 'Hi'},
          },
        ],
      };
      final response = AiResponse.fromJson(json);
      expect(response.content, equals('Hi'));
      expect(response.usage, isNull);
    });
  });

  group('AiUsage', () {
    test('fromJson parses correctly', () {
      final usage = AiUsage.fromJson({'prompt_tokens': 5, 'completion_tokens': 10});
      expect(usage.promptTokens, equals(5));
      expect(usage.completionTokens, equals(10));
    });
  });
}
