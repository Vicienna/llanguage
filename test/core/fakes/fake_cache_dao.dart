import 'package:llanguage/core/translation/translation_cache.dart';

class FakeCacheDao implements CacheDaoInterface {
  final _store = <String, String>{};

  @override
  Future<AiCacheRow?> getCache(String cacheKey) async {
    final value = _store[cacheKey];
    if (value == null) return null;
    return AiCacheRow(value);
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
    _store[cacheKey] = response;
  }

  @override
  Future<void> deleteCache(String cacheKey) async {
    _store.remove(cacheKey);
  }
}
