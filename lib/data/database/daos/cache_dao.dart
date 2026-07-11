import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/all_tables.dart';

part 'cache_dao.g.dart';

@DriftAccessor(tables: [AiCache])
class CacheDao extends DatabaseAccessor<AppDatabase> with _$CacheDaoMixin {
  final AppDatabase db;

  CacheDao(this.db) : super(db);

  Future<AiCacheData> setCache({
    required String cacheKey,
    required String prompt,
    required String response,
    required String model,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) =>
      db.into(db.aiCache).insertReturning(AiCacheCompanion.insert(
        cacheKey: cacheKey,
        prompt: prompt,
        response: response,
        model: model,
        createdAt: createdAt,
        expiresAt: expiresAt,
      ));

  Future<AiCacheData?> getCache(String cacheKey) =>
      (db.select(db.aiCache)..where((t) => t.cacheKey.equals(cacheKey))).getSingleOrNull();

  Future<int> deleteCache(String cacheKey) =>
      (db.delete(db.aiCache)..where((t) => t.cacheKey.equals(cacheKey))).go();

  Future<int> clearExpiredCache() =>
      (db.delete(db.aiCache)..where((t) => t.expiresAt.isSmallerThanValue(DateTime.now()))).go();

  Future<List<String>> getAllCacheKeys() async {
    final rows = await (db.selectOnly(db.aiCache)
          ..addColumns([db.aiCache.cacheKey]))
        .get();
    return rows.map((r) => r.read(db.aiCache.cacheKey)!).toList();
  }
}
