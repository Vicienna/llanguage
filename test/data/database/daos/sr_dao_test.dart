import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:llanguage/data/database/app_database.dart';
import 'package:llanguage/data/database/daos/sr_dao.dart';
import 'package:llanguage/data/database/tables/all_tables.dart';

void main() {
  late AppDatabase database;
  late SrDao dao;
  late int vocabId;

  setUp(() async {
    database = AppDatabase.forTest(NativeDatabase.memory());
    dao = SrDao(database);

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
    final lessonId = await database.into(database.lessons).insert(LessonsCompanion.insert(
      unitId: unitId, title: 'L1', type: 'vocab', orderIndex: 0, contentJson: '{}', isPremium: false,
    ));
    vocabId = await database.into(database.vocab).insert(VocabCompanion.insert(
      lessonId: lessonId, sourceWord: 'hello', targetWord: 'halo', partOfSpeech: Value('n'),
    ));
  });

  tearDown(() async {
    await database.close();
  });

  group('SrDao', () {
    test('initSr creates SR entry for vocab', () async {
      final now = DateTime.now();
      final sr = await dao.initSr(vocabId: vocabId, now: now);
      expect(sr.id, isNotNull);
      expect(sr.easeFactor, equals(2.5));
      expect(sr.interval, equals(0));
      expect(sr.repetitions, equals(0));
    });

    test('getSrByVocab returns SR entry', () async {
      final now = DateTime.now();
      await dao.initSr(vocabId: vocabId, now: now);
      final sr = await dao.getSrByVocab(vocabId);
      expect(sr, isNotNull);
      expect(sr!.vocabId, equals(vocabId));
    });

    test('updateSr updates spaced repetition values', () async {
      final now = DateTime.now();
      await dao.initSr(vocabId: vocabId, now: now);
      final nextReview = now.add(const Duration(days: 1));
      final updated = await dao.updateSr(
        vocabId,
        easeFactor: 2.6,
        interval: 1,
        repetitions: 1,
        nextReviewAt: nextReview,
        lastReviewAt: now,
      );
      expect(updated.first.easeFactor, equals(2.6));
      expect(updated.first.interval, equals(1));
      expect(updated.first.repetitions, equals(1));
    });

    test('getDueReviews returns vocab due for review', () async {
      final now = DateTime.now();
      await dao.initSr(vocabId: vocabId, now: now);

      final past = now.subtract(const Duration(hours: 1));
      final due = await dao.getDueReviews(upTo: past);
      expect(due.length, equals(0));

      final future = now.add(const Duration(hours: 1));
      final dueLater = await dao.getDueReviews(upTo: future);
      expect(dueLater.length, equals(1));
    });

    test('deleteSr removes SR entry', () async {
      final now = DateTime.now();
      await dao.initSr(vocabId: vocabId, now: now);
      await dao.deleteSr(vocabId);
      final sr = await dao.getSrByVocab(vocabId);
      expect(sr, isNull);
    });

    test('getAllSr returns all SR entries', () async {
      final now = DateTime.now();
      await dao.initSr(vocabId: vocabId, now: now);
      final all = await dao.getAllSr();
      expect(all.length, equals(1));
    });
  });
}
