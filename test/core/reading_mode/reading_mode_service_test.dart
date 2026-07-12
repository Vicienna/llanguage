import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:llanguage/core/reading_mode/reading_mode_service.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockClient;
  late ReadingModeService service;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockClient = MockHttpClient();
    service = ReadingModeService(client: mockClient);
  });

  tearDown(() {
    service.dispose();
  });

  group('fetchContent', () {
    test('extracts text from HTML', () async {
      final html = '''
        <html><body>
          <nav>Nav</nav>
          <article>
            <h1>Hello World</h1>
            <p>This is a <strong>test</strong> article.</p>
            <p>Second paragraph.</p>
          </article>
          <footer>Footer</footer>
        </body></html>
      ''';

      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response(html, 200),
      );

      final content = await service.fetchContent('https://example.com');
      expect(content, contains('Hello World'));
      expect(content, contains('This is a test article.'));
      expect(content, contains('Second paragraph.'));
      expect(content, isNot(contains('Nav')));
      expect(content, isNot(contains('Footer')));
    });

    test('throws on non-200', () async {
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      expect(
        () => service.fetchContent('https://example.com'),
        throwsA(isA<ReadingException>()),
      );
    });
  });

  group('extractPotentialVocab', () {
    test('extracts unique words of valid length', () {
      final words = service.extractPotentialVocab(
        'The quick brown fox jumps over the lazy dog.',
        'en',
      );
      expect(words, contains('quick'));
      expect(words, contains('brown'));
      expect(words, contains('the'));
      expect(words, isNot(contains('a')));
    });

    test('removes punctuation', () {
      final words = service.extractPotentialVocab("Hello, world! It's great.", 'en');
      expect(words, contains('hello'));
      expect(words, contains('world'));
      expect(words, contains("it's"));
      expect(words, contains('great'));
    });

    test('sorts alphabetically', () {
      final words = service.extractPotentialVocab('cat dog apple', 'en');
      expect(words, equals(['apple', 'cat', 'dog']));
    });
  });
}
