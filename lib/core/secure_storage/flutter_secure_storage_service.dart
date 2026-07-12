import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'secure_storage_service.dart';

class FlutterSecureStorageService implements SecureStorageService {
  final FlutterSecureStorage _storage;

  FlutterSecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static String _key(String name) => 'api_key_$name';

  @override
  Future<void> saveApiKey(String providerName, String apiKey) async {
    await _storage.write(key: _key(providerName), value: apiKey);
  }

  @override
  Future<String?> getApiKey(String providerName) async {
    return _storage.read(key: _key(providerName));
  }

  @override
  Future<void> deleteApiKey(String providerName) async {
    await _storage.delete(key: _key(providerName));
  }

  @override
  Future<bool> hasApiKey(String providerName) async {
    return _storage.containsKey(key: _key(providerName));
  }

  @override
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
