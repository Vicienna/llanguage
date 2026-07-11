import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:llanguage/data/database/app_database.dart';
import 'package:llanguage/data/database/daos/progress_dao.dart';
import 'package:llanguage/data/database/tables/all_tables.dart';

void main() {
  late AppDatabase database;
  late ProgressDao dao;
  late int lessonId;

  setUp(() async {
    database = AppDatabase.forTest(NativeDatabase.memory());
    dao = ProgressDao(database);

    final now = DateTime.now();
    final courseId = await database.into(database.courses).insert(CoursesCompanion.insert(
      title: 'C', sourceLang: 'en', targetLang: 'id', description: 'd', level: 'beginner', createdAt: now, updatedAt: now,
    ));
    final levelId = await database.into(database.levels).insert(LevelsCompanion.insert(
      courseId: courseId, title: 'L1', orderIndex: 0, description: 'd',
    ));
    final unitId = await database.into(database.units).insert(UnitsCompanion.insert(
      levelId: levelId, title: 'U1', orderIndex: 0, description: 'd',
    ));
    lessonId = await database.into(database.lessons).insert(LessonsCompanion.insert(
      unitId: unitId, title: 'L1', type: 'vocab', orderIndex: 0, contentJson: '{}', isPremium: false,
    ));
  });

  tearDown(() async {
    await database.close();
  });

  group('ProgressDao', () {
    test('createProgress inserts progress', () async {
      final p = await dao.createProgress(
        lessonId: lessonId, status: 'not_started',
      );
      expect(p.id, isNotNull);
      expect(p.status, equals('not_started'));
    });

    test('getProgress retrieves by id', () async {
      final created = await dao.createProgress(lessonId: lessonId, status: 'in_progress');
      final retrieved = await dao.getProgress(created.id);
      expect(retrieved, isNotNull);
    });

    test('updateProgress modifies status', () async {
      final created = await dao.createProgress(lessonId: lessonId, status: 'not_started');
      final updated = await dao.updateProgress(created.id, status: 'completed', score: 100);
      expect(updated.first.status, equals('completed'));
      expect(updated.first.score, equals(100));
    });

    test('getProgressByLesson returns progress for lesson', () async {
      await dao.createProgress(lessonId: lessonId, status: 'completed');
      final p = await dao.getProgressByLesson(lessonId);
      expect(p, isNotNull);
      expect(p!.status, equals('completed'));
    });

    test('getAllProgress returns all progress entries', () async {
      final now = DateTime.now();
      final courseId2 = await database.into(database.courses).insert(CoursesCompanion.insert(title: 'C2', sourceLang: 'en', targetLang: 'fr', description: 'd', level: 'beginner', createdAt: now, updatedAt: now));
      final levelId2 = await database.into(database.levels).insert(LevelsCompanion.insert(courseId: courseId2, title: 'L2', orderIndex: 0, description: 'd'));
      final unitId2 = await database.into(database.units).insert(UnitsCompanion.insert(levelId: levelId2, title: 'U2', orderIndex: 0, description: 'd'));
      final lessonId2 = await database.into(database.lessons).insert(LessonsCompanion.insert(unitId: unitId2, title: 'L2', type: 'grammar', orderIndex: 0, contentJson: '{}', isPremium: false));

      await dao.createProgress(lessonId: lessonId, status: 'completed');
      await dao.createProgress(lessonId: lessonId2, status: 'in_progress');
      final all = await dao.getAllProgress();
      expect(all.length, equals(2));
    });

    test('getCompletedLessons returns only completed', () async {
      final now = DateTime.now();
      final courseId2 = await database.into(database.courses).insert(CoursesCompanion.insert(title: 'C2', sourceLang: 'en', targetLang: 'fr', description: 'd', level: 'beginner', createdAt: now, updatedAt: now));
      final levelId2 = await database.into(database.levels).insert(LevelsCompanion.insert(courseId: courseId2, title: 'L2', orderIndex: 0, description: 'd'));
      final unitId2 = await database.into(database.units).insert(UnitsCompanion.insert(levelId: levelId2, title: 'U2', orderIndex: 0, description: 'd'));
      final lessonId2 = await database.into(database.lessons).insert(LessonsCompanion.insert(unitId: unitId2, title: 'L2', type: 'grammar', orderIndex: 0, contentJson: '{}', isPremium: false));

      await dao.createProgress(lessonId: lessonId, status: 'completed', score: 100);
      await dao.createProgress(lessonId: lessonId2, status: 'in_progress');
      final completed = await dao.getCompletedLessons();
      expect(completed.length, equals(1));
      expect(completed.first.lessonId, equals(lessonId));
    });
  });
}
