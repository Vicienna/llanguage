import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ai/services/ai_service.dart';
import '../secure_storage/flutter_secure_storage_service.dart';
import '../secure_storage/in_memory_secure_storage_service.dart';
import '../secure_storage/secure_storage_service.dart';

class _ProviderVersion extends Notifier<int> {
  @override
  int build() => 0;
  void bump() => state++;
}

final _providerVersionProvider = NotifierProvider<_ProviderVersion, int>(_ProviderVersion.new);

final aiServiceProvider = Provider<AiService>((ref) {
  ref.watch(_providerVersionProvider);
  return AiService.instance;
});

void bumpProviderVersion(WidgetRef ref) {
  ref.read(_providerVersionProvider.notifier).bump();
}

class _SecureStorage extends Notifier<SecureStorageService> {
  @override
  SecureStorageService build() {
    try {
      return FlutterSecureStorageService();
    } catch (_) {
      return InMemorySecureStorageService();
    }
  }
}

final secureStorageProvider = NotifierProvider<_SecureStorage, SecureStorageService>(_SecureStorage.new);
