import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/all_tables.dart';

part 'mistake_dao.g.dart';

@DriftAccessor(tables: [UserMistakes])
class MistakeDao extends DatabaseAccessor<AppDatabase> with _$MistakeDaoMixin {
  final AppDatabase db;

  MistakeDao(this.db) : super(db);

  Future<UserMistake> addMistake({
    required int vocabId,
    required String mistakeType,
    required String mistakeText,
    required String correction,
    required DateTime createdAt,
  }) =>
      db.into(db.userMistakes).insertReturning(UserMistakesCompanion.insert(
        vocabId: vocabId,
        mistakeType: mistakeType,
        mistakeText: mistakeText,
        correction: correction,
        count: 1,
        createdAt: createdAt,
      ));

  Future<List<UserMistake>> getMistakesByVocab(int vocabId) =>
      (db.select(db.userMistakes)..where((t) => t.vocabId.equals(vocabId))).get();

  Future<List<UserMistake>> getAllMistakes() => db.select(db.userMistakes).get();

  Future<List<UserMistake>> incrementMistakeCount(int id) async {
    final current = await (db.select(db.userMistakes)..where((t) => t.id.equals(id))).getSingle();
    return (db.update(db.userMistakes)..where((t) => t.id.equals(id))).writeReturning(
      UserMistakesCompanion(count: Value(current.count + 1)),
    );
  }

  Future<int> deleteMistake(int id) =>
      (db.delete(db.userMistakes)..where((t) => t.id.equals(id))).go();
}
