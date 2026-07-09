import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:llanguage/data/database/app_database.dart';
import 'package:llanguage/data/database/daos/cache_dao.dart';
import 'package:llanguage/data/database/tables/all_tables.dart';

void main() {
  late AppDatabase database;
  late CacheDao dao;

  setUp(() {
    database = AppDatabase.forTest(NativeDatabase.memory());
    dao = CacheDao(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('CacheDao', () {
    test('setCache creates a cache entry', () async {
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 1));
      final cache = await dao.setCache(
        cacheKey: 'translate:hello:en:id',
        prompt: 'Translate hello to Indonesian',
        response: 'Halo',
        model: 'gpt-4',
        createdAt: now,
        expiresAt: expiresAt,
      );
      expect(cache.id, isNotNull);
      expect(cache.cacheKey, equals('translate:hello:en:id'));
    });

    test('getCache returns entry by key', () async {
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 1));
      await dao.setCache(cacheKey: 'test-key', prompt: 'p', response: 'r', model: 'm', createdAt: now, expiresAt: expiresAt);
      final cache = await dao.getCache('test-key');
      expect(cache, isNotNull);
      expect(cache!.response, equals('r'));
    });

    test('getCache returns null for missing key', () async {
      final cache = await dao.getCache('nonexistent');
      expect(cache, isNull);
    });

    test('deleteCache removes entry by key', () async {
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 1));
      await dao.setCache(cacheKey: 'delete-me', prompt: 'p', response: 'r', model: 'm', createdAt: now, expiresAt: expiresAt);
      await dao.deleteCache('delete-me');
      final cache = await dao.getCache('delete-me');
      expect(cache, isNull);
    });

    test('clearExpiredCache removes expired entries', () async {
      final now = DateTime.now();
      final expiresAt = now.subtract(const Duration(hours: 1));
      await dao.setCache(cacheKey: 'expired', prompt: 'p', response: 'r', model: 'm', createdAt: now, expiresAt: expiresAt);
      await dao.clearExpiredCache();
      final cache = await dao.getCache('expired');
      expect(cache, isNull);
    });

    test('getAllCacheKeys returns all keys', () async {
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 1));
      await dao.setCache(cacheKey: 'key1', prompt: 'p', response: 'r', model: 'm', createdAt: now, expiresAt: expiresAt);
      await dao.setCache(cacheKey: 'key2', prompt: 'p', response: 'r', model: 'm', createdAt: now, expiresAt: expiresAt);
      final keys = await dao.getAllCacheKeys();
      expect(keys, containsAll(['key1', 'key2']));
    });
  });
}
