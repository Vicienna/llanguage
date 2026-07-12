import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:llanguage/core/ai/models/ai_request.dart';
import 'package:llanguage/core/ai/providers/openai_compatible.dart';

class MockHttpClient extends http.BaseClient {
  int statusCode = 200;
  Map<String, dynamic>? responseBody;
  int requestCount = 0;

  void returns(int code, Map<String, dynamic> body) {
    statusCode = code;
    responseBody = body;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    requestCount++;
    final body = responseBody != null ? jsonEncode(responseBody!) : '';
    return http.StreamedResponse(
      Stream.value(utf8.encode(body)),
      statusCode,
      headers: {'content-type': 'application/json'},
    );
  }
}

void main() {
  late OpenAiCompatible provider;
  late MockHttpClient mockClient;

  setUp(() {
    mockClient = MockHttpClient();
    provider = OpenAiCompatible(
      name: 'Test',
      baseUrl: 'https://test.api.com',
      defaultModel: 'test-model',
      client: mockClient,
    );
  });

  group('OpenAiCompatible', () {
    test('properties are set correctly', () {
      expect(provider.name, equals('Test'));
      expect(provider.baseUrl, equals('https://test.api.com'));
      expect(provider.defaultModel, equals('test-model'));
      expect(provider.apiKeyRequired, isTrue);
      expect(provider.supportsStreaming(), isTrue);
    });

    test('chat sends request and parses response', () async {
      mockClient.returns(200, {
        'id': 'cmpl-123',
        'object': 'chat.completion',
        'created': 1677652288,
        'model': 'test-model',
        'choices': [
          {
            'index': 0,
            'message': {'role': 'assistant', 'content': 'Test response'},
            'finish_reason': 'stop',
          },
        ],
        'usage': {'prompt_tokens': 5, 'completion_tokens': 7},
      });

      final request = AiRequest(
        model: 'test-model',
        messages: [AiMessage(role: 'user', content: 'Hello')],
      );

      final response = await provider.chat(request, apiKey: 'sk-test');
      expect(response.content, equals('Test response'));
      expect(response.model, equals('test-model'));
      expect(response.usage!.promptTokens, equals(5));
      expect(mockClient.requestCount, equals(1));
    });

    test('chat throws on non-200', () async {
      mockClient.returns(401, {'error': 'unauthorized'});

      final request = AiRequest(
        model: 'test-model',
        messages: [AiMessage(role: 'user', content: 'Hi')],
      );

      expect(
        () => provider.chat(request, apiKey: 'bad-key'),
        throwsA(isA<AiProviderException>()),
      );
    });
  });
}
