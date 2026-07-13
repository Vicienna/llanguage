import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ai/services/ai_service.dart';
import '../secure_storage/flutter_secure_storage_service.dart';
import '../secure_storage/in_memory_secure_storage_service.dart';
import '../secure_storage/secure_storage_service.dart';

final _providerVersionProvider = StateProvider<int>((ref) => 0);

final aiServiceProvider = Provider<AiService>((ref) {
  ref.watch(_providerVersionProvider);
  return AiService.instance;
});

void bumpProviderVersion(WidgetRef ref) {
  ref.read(_providerVersionProvider.notifier).state++;
}

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  try {
    return FlutterSecureStorageService();
  } catch (_) {
    return InMemorySecureStorageService();
  }
});
