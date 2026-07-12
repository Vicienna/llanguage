import 'package:flutter_test/flutter_test.dart';
import 'package:llanguage/core/translation/models/translation_result.dart';

void main() {
  group('TranslationResult', () {
    test('fromJson parses full result', () {
      final json = {
        'translated_text': 'halo',
        'source_text': 'hello',
        'detected_source_lang': 'en',
        'target_lang': 'id',
        'word_breakdown': [
          {'word': 'hello', 'translation': 'halo', 'definition': 'greeting'},
        ],
        'definitions': ['a greeting'],
      };

      final result = TranslationResult.fromJson(json);

      expect(result.translatedText, equals('halo'));
      expect(result.sourceText, equals('hello'));
      expect(result.detectedSourceLang, equals('en'));
      expect(result.targetLang, equals('id'));
      expect(result.wordBreakdown.length, equals(1));
      expect(result.wordBreakdown[0].word, equals('hello'));
      expect(result.wordBreakdown[0].translation, equals('halo'));
      expect(result.wordBreakdown[0].definition, equals('greeting'));
      expect(result.definitions, contains('a greeting'));
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'translated_text': 'halo',
        'source_text': 'hello',
        'target_lang': 'id',
      };

      final result = TranslationResult.fromJson(json);

      expect(result.detectedSourceLang, equals('auto'));
      expect(result.wordBreakdown, isEmpty);
      expect(result.definitions, isEmpty);
    });

    test('toJson and fromJson roundtrip', () {
      final original = TranslationResult(
        translatedText: 'halo',
        sourceText: 'hello',
        detectedSourceLang: 'en',
        targetLang: 'id',
        wordBreakdown: [
          WordBreakdown(word: 'hello', translation: 'halo'),
        ],
        definitions: ['greeting'],
      );

      final json = original.toJson();
      final restored = TranslationResult.fromJson(json);

      expect(restored.translatedText, equals(original.translatedText));
      expect(restored.wordBreakdown.length, equals(original.wordBreakdown.length));
      expect(restored.wordBreakdown[0].word, equals(original.wordBreakdown[0].word));
      expect(restored.definitions, equals(original.definitions));
    });
  });

  group('WordBreakdown', () {
    test('fromJson parses with all fields', () {
      final json = {
        'word': 'hello',
        'translation': 'halo',
        'definition': 'a greeting',
      };

      final wb = WordBreakdown.fromJson(json);

      expect(wb.word, equals('hello'));
      expect(wb.translation, equals('halo'));
      expect(wb.definition, equals('a greeting'));
    });

    test('fromJson handles null optional fields', () {
      final json = {'word': 'hello'};

      final wb = WordBreakdown.fromJson(json);

      expect(wb.word, equals('hello'));
      expect(wb.translation, isNull);
      expect(wb.definition, isNull);
    });

    test('toJson omits null fields', () {
      final wb = WordBreakdown(word: 'hello');
      final json = wb.toJson();
      expect(json['word'], equals('hello'));
      expect(json.containsKey('translation'), isFalse);
      expect(json.containsKey('definition'), isFalse);
    });
  });
}
