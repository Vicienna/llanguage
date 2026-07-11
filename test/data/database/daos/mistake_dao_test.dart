import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:llanguage/data/database/app_database.dart';
import 'package:llanguage/data/database/daos/mistake_dao.dart';
import 'package:llanguage/data/database/tables/all_tables.dart';

void main() {
  late AppDatabase database;
  late MistakeDao dao;
  late int vocabId;

  setUp(() async {
    database = AppDatabase.forTest(NativeDatabase.memory());
    dao = MistakeDao(database);

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

  group('MistakeDao', () {
    test('addMistakes creates a mistake entry', () async {
      final now = DateTime.now();
      final m = await dao.addMistake(
        vocabId: vocabId,
        mistakeType: 'spelling',
        mistakeText: 'helo',
        correction: 'hello',
        createdAt: now,
      );
      expect(m.id, isNotNull);
      expect(m.mistakeType, equals('spelling'));
      expect(m.count, equals(1));
    });

    test('getMistakesByVocab returns mistakes for a vocab', () async {
      final now = DateTime.now();
      await dao.addMistake(vocabId: vocabId, mistakeType: 'spelling', mistakeText: 'helo', correction: 'hello', createdAt: now);
      await dao.addMistake(vocabId: vocabId, mistakeType: 'pronunciation', mistakeText: 'heyo', correction: 'hello', createdAt: now);
      final mistakes = await dao.getMistakesByVocab(vocabId);
      expect(mistakes.length, equals(2));
    });

    test('getAllMistakes returns all mistakes', () async {
      final now = DateTime.now();
      await dao.addMistake(vocabId: vocabId, mistakeType: 'spelling', mistakeText: 'helo', correction: 'hello', createdAt: now);
      final all = await dao.getAllMistakes();
      expect(all.length, equals(1));
    });

    test('incrementMistakeCount increases count', () async {
      final now = DateTime.now();
      final created = await dao.addMistake(vocabId: vocabId, mistakeType: 'spelling', mistakeText: 'helo', correction: 'hello', createdAt: now);
      final updated = await dao.incrementMistakeCount(created.id);
      expect(updated.first.count, equals(2));
    });

    test('deleteMistake removes the mistake', () async {
      final now = DateTime.now();
      final created = await dao.addMistake(vocabId: vocabId, mistakeType: 'spelling', mistakeText: 'helo', correction: 'hello', createdAt: now);
      await dao.deleteMistake(created.id);
      final retrieved = await (database.select(database.userMistakes)..where((t) => t.id.equals(created.id))).getSingleOrNull();
      expect(retrieved, isNull);
    });
  });
}
