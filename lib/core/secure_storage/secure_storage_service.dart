abstract class SecureStorageService {
  Future<void> saveApiKey(String providerName, String apiKey);
  Future<String?> getApiKey(String providerName);
  Future<void> deleteApiKey(String providerName);
  Future<bool> hasApiKey(String providerName);
  Future<void> clearAll();
}
