import 'package:flutter_test/flutter_test.dart';
import 'package:llanguage/core/duckduckgo/duckduckgo_result.dart';

void main() {
  group('DdgResult', () {
    test('parses full instant answer JSON', () {
      final json = {
        'Abstract': 'Dog is a domesticated mammal.',
        'AbstractSource': 'Wikipedia',
        'Answer': '',
        'Definition': '',
        'Heading': 'Dog',
        'Image': 'https://example.com/dog.jpg',
        'RelatedTopics': [
          {
            'Result': '<a href="https://example.com/wolf">Wolf</a>',
            'FirstURL': 'https://example.com/wolf',
            'Icon': {'URL': 'https://example.com/wolf.png'},
          },
        ],
      };

      final result = DdgResult.fromJson('dog', json);

      expect(result.query, equals('dog'));
      expect(result.abstractText, equals('Dog is a domesticated mammal.'));
      expect(result.abstractSource, equals('Wikipedia'));
      expect(result.answer, isEmpty);
      expect(result.definition, isEmpty);
      expect(result.relatedTopics.length, equals(1));
      expect(result.relatedTopics[0].text, equals('Wolf'));
      expect(result.relatedTopics[0].firstUrl, equals('https://example.com/wolf'));
      expect(result.relatedTopics[0].iconUrl, equals('https://example.com/wolf.png'));
      expect(result.images.length, equals(1));
      expect(result.images[0].url, equals('https://example.com/dog.jpg'));
    });

    test('parses minimal JSON with no results', () {
      final json = <String, dynamic>{};

      final result = DdgResult.fromJson('nothing', json);

      expect(result.query, equals('nothing'));
      expect(result.abstractText, isNull);
      expect(result.relatedTopics, isEmpty);
      expect(result.images, isEmpty);
    });

    test('parses RelatedTopics with null Result', () {
      final json = {
        'RelatedTopics': [
          {'FirstURL': 'https://example.com/test'},
        ],
      };

      final result = DdgResult.fromJson('test', json);

      expect(result.relatedTopics, isEmpty);
    });

    test('handles null RelatedTopics', () {
      final json = {'RelatedTopics': null};

      final result = DdgResult.fromJson('test', json);

      expect(result.relatedTopics, isEmpty);
    });

    test('handles null Image', () {
      final json = {'Image': null};

      final result = DdgResult.fromJson('test', json);

      expect(result.images, isEmpty);
    });
  });
}
