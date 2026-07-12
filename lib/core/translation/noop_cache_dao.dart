import 'translation_cache.dart';

class NoOpCacheDao implements CacheDaoInterface {
  @override
  Future<AiCacheRow?> getCache(String cacheKey) async => null;

  @override
  Future<void> deleteCache(String cacheKey) async {}

  @override
  Future<void> setCache({
    required String cacheKey,
    required String prompt,
    required String response,
    required String model,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) async {}
}
