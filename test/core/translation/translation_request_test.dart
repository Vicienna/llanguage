import 'package:flutter_test/flutter_test.dart';
import 'package:llanguage/core/translation/models/translation_request.dart';

void main() {
  group('TranslationRequest', () {
    test('creates with required params', () {
      final req = TranslationRequest(text: 'hello', targetLang: 'id');
      expect(req.text, equals('hello'));
      expect(req.sourceLang, equals('auto'));
      expect(req.targetLang, equals('id'));
    });

    test('toJson serializes correctly', () {
      final req = TranslationRequest(
        text: 'hello',
        sourceLang: 'en',
        targetLang: 'id',
      );
      final json = req.toJson();
      expect(json['text'], equals('hello'));
      expect(json['source_lang'], equals('en'));
      expect(json['target_lang'], equals('id'));
    });

    test('toJson uses auto for default sourceLang', () {
      final req = TranslationRequest(text: 'hello', targetLang: 'id');
      final json = req.toJson();
      expect(json['source_lang'], equals('auto'));
    });
  });
}
