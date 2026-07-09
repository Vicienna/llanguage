import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:llanguage/data/database/app_database.dart';
import 'package:llanguage/data/database/daos/vocab_dao.dart';
import 'package:llanguage/data/database/tables/all_tables.dart';

void main() {
  late AppDatabase database;
  late VocabDao dao;
  late int lessonId;

  setUp(() async {
    database = AppDatabase.forTest(NativeDatabase.memory());
    dao = VocabDao(database);

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
      unitId: unitId, title: 'L1', type: 'vocab', contentJson: '{}', isPremium: false,
    ));
  });

  tearDown(() async {
    await database.close();
  });

  group('VocabDao', () {
    test('createVocab inserts a vocab entry', () async {
      final v = await dao.createVocab(
        lessonId: lessonId, sourceWord: 'hello', targetWord: 'halo',
      );
      expect(v.id, isNotNull);
      expect(v.sourceWord, equals('hello'));
    });

    test('getVocab retrieves by id', () async {
      final created = await dao.createVocab(lessonId: lessonId, sourceWord: 'good', targetWord: 'baik');
      final retrieved = await dao.getVocab(created.id);
      expect(retrieved, isNotNull);
      expect(retrieved!.id, equals(created.id));
    });

    test('getVocabByLesson returns all vocab for a lesson', () async {
      await dao.createVocab(lessonId: lessonId, sourceWord: 'a', targetWord: 'x');
      await dao.createVocab(lessonId: lessonId, sourceWord: 'b', targetWord: 'y');
      final list = await dao.getVocabByLesson(lessonId);
      expect(list.length, equals(2));
    });

    test('updateVocab modifies a vocab entry', () async {
      final created = await dao.createVocab(lessonId: lessonId, sourceWord: 'original', targetWord: 'asli');
      final updated = await dao.updateVocab(created.id, sourceWord: 'updated');
      expect(updated.sourceWord, equals('updated'));
    });

    test('deleteVocab removes entry', () async {
      final created = await dao.createVocab(lessonId: lessonId, sourceWord: 'temp', targetWord: 'sementara');
      await dao.deleteVocab(created.id);
      final retrieved = await dao.getVocab(created.id);
      expect(retrieved, isNull);
    });

    test('searchVocab by source word', () async {
      await dao.createVocab(lessonId: lessonId, sourceWord: 'apple', targetWord: 'apel');
      await dao.createVocab(lessonId: lessonId, sourceWord: 'application', targetWord: 'aplikasi');
      await dao.createVocab(lessonId: lessonId, sourceWord: 'banana', targetWord: 'pisang');
      final results = await dao.searchVocab('app');
      expect(results.length, equals(2));
    });

    test('getVocabByPartOfSpeech filters correctly', () async {
      await dao.createVocab(lessonId: lessonId, sourceWord: 'run', targetWord: 'lari', partOfSpeech: 'verb');
      await dao.createVocab(lessonId: lessonId, sourceWord: 'happy', targetWord: 'senang', partOfSpeech: 'adjective');
      final verbs = await dao.getVocabByPartOfSpeech('verb');
      expect(verbs.length, equals(1));
      expect(verbs.first.sourceWord, equals('run'));
    });
  });
}
