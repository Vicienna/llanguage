import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ai/services/ai_service.dart';
import '../secure_storage/secure_storage_service.dart';
import '../secure_storage/flutter_secure_storage_service.dart';
import '../secure_storage/in_memory_secure_storage_service.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  try {
    return FlutterSecureStorageService();
  } catch (_) {
    return InMemorySecureStorageService();
  }
});

final aiServiceProvider = Provider<AiService>((ref) {
  final service = AiService();
  service.loadPresets();
  return service;
});

final currentApiKeyProvider = FutureProvider.family<String?, String>((ref, providerName) async {
  final storage = ref.read(secureStorageProvider);
  return storage.getApiKey(providerName);
});
