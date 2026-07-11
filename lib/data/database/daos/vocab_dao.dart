import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/all_tables.dart';

part 'vocab_dao.g.dart';

@DriftAccessor(tables: [Vocab])
class VocabDao extends DatabaseAccessor<AppDatabase> with _$VocabDaoMixin {
  final AppDatabase db;

  VocabDao(this.db) : super(db);

  Future<VocabData> createVocab({
    required int lessonId,
    required String sourceWord,
    required String targetWord,
    String? pronunciation,
    String? exampleSentence,
    String? imageUrl,
    String? partOfSpeech,
  }) =>
      db.into(db.vocab).insertReturning(VocabCompanion.insert(
        lessonId: lessonId,
        sourceWord: sourceWord,
        targetWord: targetWord,
        pronunciation: Value(pronunciation),
        exampleSentence: Value(exampleSentence),
        imageUrl: Value(imageUrl),
        partOfSpeech: Value(partOfSpeech),
      ));

  Future<VocabData?> getVocab(int id) =>
      (db.select(db.vocab)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<VocabData>> getVocabByLesson(int lessonId) =>
      (db.select(db.vocab)..where((t) => t.lessonId.equals(lessonId))).get();

  Future<List<VocabData>> updateVocab(
    int id, {
    String? sourceWord,
    String? targetWord,
    String? pronunciation,
    String? exampleSentence,
    String? imageUrl,
    String? partOfSpeech,
  }) =>
      (db.update(db.vocab)..where((t) => t.id.equals(id))).writeReturning(VocabCompanion(
        sourceWord: sourceWord != null ? Value(sourceWord) : Value.absent(),
        targetWord: targetWord != null ? Value(targetWord) : Value.absent(),
        pronunciation: Value(pronunciation),
        exampleSentence: Value(exampleSentence),
        imageUrl: Value(imageUrl),
        partOfSpeech: Value(partOfSpeech),
      ));

  Future<int> deleteVocab(int id) =>
      (db.delete(db.vocab)..where((t) => t.id.equals(id))).go();

  Future<List<VocabData>> searchVocab(String query) =>
      (db.select(db.vocab)..where((t) => t.sourceWord.like('%$query%'))).get();

  Future<List<VocabData>> getVocabByPartOfSpeech(String partOfSpeech) =>
      (db.select(db.vocab)..where((t) => t.partOfSpeech.equals(partOfSpeech))).get();
}
