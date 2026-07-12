import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final databaseInitProvider = FutureProvider<void>((ref) async {
  final db = ref.read(databaseProvider);
  await db.customSelect('SELECT 1').get();
});
