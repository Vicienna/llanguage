import 'secure_storage_service.dart';

class InMemorySecureStorageService implements SecureStorageService {
  final _store = <String, String>{};

  @override
  Future<void> saveApiKey(String providerName, String apiKey) async {
    _store['api_key_$providerName'] = apiKey;
  }

  @override
  Future<String?> getApiKey(String providerName) async {
    return _store['api_key_$providerName'];
  }

  @override
  Future<void> deleteApiKey(String providerName) async {
    _store.remove('api_key_$providerName');
  }

  @override
  Future<bool> hasApiKey(String providerName) async {
    return _store.containsKey('api_key_$providerName');
  }

  @override
  Future<void> clearAll() async {
    _store.clear();
  }
}
