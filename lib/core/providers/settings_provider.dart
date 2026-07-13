import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ai_providers.dart';

class _ActiveProviderName extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? name) => state = name;
}

final activeProviderNameProvider = NotifierProvider<_ActiveProviderName, String?>(_ActiveProviderName.new);

Future<void> setActiveProvider(WidgetRef ref, String name) async {
  ref.read(aiServiceProvider).setActiveProvider(name);
  ref.read(activeProviderNameProvider.notifier).set(name);
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
