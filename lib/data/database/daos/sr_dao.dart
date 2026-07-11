import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/all_tables.dart';

part 'sr_dao.g.dart';

@DriftAccessor(tables: [UserVocabSr])
class SrDao extends DatabaseAccessor<AppDatabase> with _$SrDaoMixin {
  final AppDatabase db;

  SrDao(this.db) : super(db);

  Future<UserVocabSrData> initSr({
    required int vocabId,
    required DateTime now,
  }) =>
      db.into(db.userVocabSr).insertReturning(UserVocabSrCompanion.insert(
        vocabId: vocabId,
        easeFactor: 2.5,
        interval: 0,
        repetitions: 0,
        nextReviewAt: now,
      ));

  Future<UserVocabSrData?> getSrByVocab(int vocabId) =>
      (db.select(db.userVocabSr)..where((t) => t.vocabId.equals(vocabId))).getSingleOrNull();

  Future<UserVocabSrData> updateSr(
    int vocabId, {
    required double easeFactor,
    required int interval,
    required int repetitions,
    required DateTime nextReviewAt,
    DateTime? lastReviewAt,
  }) =>
      (db.update(db.userVocabSr)..where((t) => t.vocabId.equals(vocabId))).writeReturning(
        UserVocabSrCompanion(
          easeFactor: Value(easeFactor),
          interval: Value(interval),
          repetitions: Value(repetitions),
          nextReviewAt: Value(nextReviewAt),
          lastReviewAt: lastReviewAt != null ? Value(lastReviewAt) : Value.absent(),
        ),
      );

  Future<List<UserVocabSrData>> getDueReviews({required DateTime upTo}) =>
      (db.select(db.userVocabSr)..where((t) => t.nextReviewAt.isSmallerThanValue(upTo))).get();

  Future<int> deleteSr(int vocabId) =>
      (db.delete(db.userVocabSr)..where((t) => t.vocabId.equals(vocabId))).go();

  Future<List<UserVocabSrData>> getAllSr() => db.select(db.userVocabSr).get();
}
