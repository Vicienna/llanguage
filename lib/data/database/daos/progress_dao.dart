import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/all_tables.dart';

part 'progress_dao.g.dart';

@DriftAccessor(tables: [UserLessonProgress])
class ProgressDao extends DatabaseAccessor<AppDatabase> with _$ProgressDaoMixin {
  final AppDatabase db;

  ProgressDao(this.db) : super(db);

  Future<UserLessonProgress> createProgress({
    required int lessonId,
    required String status,
    int? score,
    DateTime? completedAt,
    int? timeSpentSeconds,
  }) =>
      db.into(db.userLessonProgress).insertReturning(UserLessonProgressCompanion.insert(
        lessonId: lessonId,
        status: status,
        score: Value(score),
        completedAt: Value(completedAt),
        timeSpentSeconds: Value(timeSpentSeconds),
      ));

  Future<UserLessonProgress?> getProgress(int id) =>
      (db.select(db.userLessonProgress)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<UserLessonProgress> updateProgress(
    int id, {
    String? status,
    int? score,
    DateTime? completedAt,
    int? timeSpentSeconds,
  }) =>
      (db.update(db.userLessonProgress)..where((t) => t.id.equals(id))).writeReturning(
        UserLessonProgressCompanion(
          status: Value(status),
          score: Value(score),
          completedAt: Value(completedAt),
          timeSpentSeconds: Value(timeSpentSeconds),
        ),
      );

  Future<UserLessonProgress?> getProgressByLesson(int lessonId) =>
      (db.select(db.userLessonProgress)..where((t) => t.lessonId.equals(lessonId))).getSingleOrNull();

  Future<List<UserLessonProgress>> getAllProgress() =>
      db.select(db.userLessonProgress).get();

  Future<List<UserLessonProgress>> getCompletedLessons() =>
      (db.select(db.userLessonProgress)..where((t) => t.status.equals('completed'))).get();
}
