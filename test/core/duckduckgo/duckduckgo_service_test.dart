import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:llanguage/core/duckduckgo/duckduckgo_result.dart';
import 'package:llanguage/core/duckduckgo/duckduckgo_service.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockClient;
  late DuckDuckGoService service;

  setUp(() {
    mockClient = MockHttpClient();
    service = DuckDuckGoService(client: mockClient);
  });

  tearDown(() {
    service.dispose();
  });

  group('instantAnswer', () {
    test('returns DdgResult on success', () async {
      final responseJson = {
        'Abstract': 'Dog is a domesticated mammal.',
        'RelatedTopics': [],
      };

      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response(jsonEncode(responseJson), 200),
      );

      final result = await service.instantAnswer('dog');

      expect(result, isA<DdgResult>());
      expect(result.query, equals('dog'));
      expect(result.abstractText, equals('Dog is a domesticated mammal.'));

      final capturedUri = verify(() => mockClient.get(captureAny())).captured.first as Uri;
      expect(capturedUri.queryParameters['q'], equals('dog'));
      expect(capturedUri.queryParameters['format'], equals('json'));
    });

    test('throws DdgException on non-200', () async {
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      expect(
        () => service.instantAnswer('test'),
        throwsA(isA<DdgException>()),
      );
    });
  });

  test('dispose closes client', () async {
    when(() => mockClient.close()).thenAnswer((_) async => () {});

    service.dispose();

    verify(() => mockClient.close()).called(1);
  });
}
