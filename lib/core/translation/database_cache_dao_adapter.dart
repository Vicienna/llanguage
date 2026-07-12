import '../../data/database/daos/cache_dao.dart';
import 'translation_cache.dart';

class DatabaseCacheDaoAdapter implements CacheDaoInterface {
  final CacheDao _dao;

  DatabaseCacheDaoAdapter(this._dao);

  @override
  Future<AiCacheRow?> getCache(String cacheKey) async {
    final row = await _dao.getCache(cacheKey);
    if (row == null) return null;
    return AiCacheRow(row.response);
  }

  @override
  Future<void> deleteCache(String cacheKey) async {
    await _dao.deleteCache(cacheKey);
  }

  @override
  Future<void> setCache({
    required String cacheKey,
    required String prompt,
    required String response,
    required String model,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) async {
    await _dao.setCache(
      cacheKey: cacheKey,
      prompt: prompt,
      response: response,
      model: model,
      createdAt: createdAt,
      expiresAt: expiresAt,
    );
  }
}
