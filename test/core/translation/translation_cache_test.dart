import 'package:flutter_test/flutter_test.dart';
import 'package:llanguage/core/translation/translation_cache.dart';
import 'package:llanguage/core/translation/models/translation_request.dart';
import 'package:llanguage/core/translation/models/translation_result.dart';
import '../fakes/fake_cache_dao.dart';

void main() {
  late TranslationCache cache;
  late FakeCacheDao dao;

  setUp(() {
    dao = FakeCacheDao();
    cache = TranslationCache(dao);
  });

  group('TranslationCache', () {
    final request = TranslationRequest(text: 'hello', targetLang: 'id');
    final result = TranslationResult(
      translatedText: 'halo',
      sourceText: 'hello',
      detectedSourceLang: 'en',
      targetLang: 'id',
    );

    test('returns null for uncached request', () async {
      expect(await cache.get(request), isNull);
    });

    test('stores and retrieves cached result', () async {
      await cache.set(request, result);
      final cached = await cache.get(request);
      expect(cached, isNotNull);
      expect(cached!.translatedText, equals('halo'));
      expect(cached.sourceText, equals('hello'));
    });

    test('cache key is based on text, source, and target', () async {
      final differentRequest = TranslationRequest(text: 'goodbye', targetLang: 'id');
      await cache.set(request, result);
      expect(await cache.get(differentRequest), isNull);
    });

    test('overwrites existing cache', () async {
      await cache.set(request, result);
      final updated = TranslationResult(
        translatedText: 'hai',
        sourceText: 'hello',
        detectedSourceLang: 'en',
        targetLang: 'id',
      );
      await cache.set(request, updated);
      final cached = await cache.get(request);
      expect(cached!.translatedText, equals('hai'));
    });
  });
}
