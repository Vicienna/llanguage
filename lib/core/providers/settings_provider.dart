import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ai_providers.dart';

final activeProviderNameProvider = StateProvider<String?>((ref) => null);

final settingsInitProvider = FutureProvider<void>((ref) async {
  final storage = ref.read(secureStorageProvider);
  final saved = await storage.getApiKey('_active_provider');
  if (saved != null) {
    ref.read(aiServiceProvider).setActiveProvider(saved);
    ref.read(activeProviderNameProvider).state = saved;
  }
});

Future<void> setActiveProvider(WidgetRef ref, String name) async {
  ref.read(aiServiceProvider).setActiveProvider(name);
  ref.read(activeProviderNameProvider).state = name;
  final storage = ref.read(secureStorageProvider);
  await storage.saveApiKey('_active_provider', name);
}

Future<void> addCustomProvider(WidgetRef ref, {
  required String name,
  required String baseUrl,
  required String defaultModel,
  bool apiKeyRequired = true,
}) async {
  ref.read(aiServiceProvider).addCustomProvider(
    name: name,
    baseUrl: baseUrl,
    defaultModel: defaultModel,
    apiKeyRequired: apiKeyRequired,
  );
  bumpProviderVersion(ref);
}
