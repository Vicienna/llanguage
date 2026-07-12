import 'dart:convert';
import 'models/translation_request.dart';
import 'models/translation_result.dart';

abstract class CacheDaoInterface {
  Future<AiCacheRow?> getCache(String cacheKey);
  Future<void> deleteCache(String cacheKey);
  Future<void> setCache({
    required String cacheKey,
    required String prompt,
    required String response,
    required String model,
    required DateTime createdAt,
    required DateTime expiresAt,
  });
}

class AiCacheRow {
  final String response;
  AiCacheRow(this.response);
}

class TranslationCache {
  final CacheDaoInterface _dao;

  TranslationCache(this._dao);

  Future<TranslationResult?> get(TranslationRequest request) async {
    final cacheKey = 'trans:${request.text}:${request.sourceLang}:${request.targetLang}';
    final row = await _dao.getCache(cacheKey);
    if (row == null) return null;
    final json = jsonDecode(row.response) as Map<String, dynamic>;
    return TranslationResult.fromJson(json);
  }

  Future<void> set(
    TranslationRequest request,
    TranslationResult result,
  ) async {
    final cacheKey = 'trans:${request.text}:${request.sourceLang}:${request.targetLang}';
    await _dao.deleteCache(cacheKey);
    await _dao.setCache(
      cacheKey: cacheKey,
      prompt: request.toJson().toString(),
      response: jsonEncode(result.toJson()),
      model: 'translation_cache',
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );
  }
}
