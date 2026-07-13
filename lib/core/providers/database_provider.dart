import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../ai/services/ai_service.dart';
import 'ai_providers.dart';
import 'settings_provider.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final databaseInitProvider = FutureProvider<void>((ref) async {
  AiService.instance.loadPresets();
  final storage = ref.read(secureStorageProvider);
  final saved = await storage.getApiKey('_active_provider');
  if (saved != null) {
    ref.read(aiServiceProvider).setActiveProvider(saved);
    ref.read(activeProviderNameProvider.notifier).set(saved);
  }
  final db = ref.read(databaseProvider);
  await db.customSelect('SELECT 1').get();
});
