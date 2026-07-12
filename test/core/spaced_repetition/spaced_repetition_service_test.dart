import 'package:flutter_test/flutter_test.dart';
import 'package:llanguage/data/database/app_database.dart';
import 'package:llanguage/data/database/daos/sr_dao.dart';
import 'package:llanguage/core/spaced_repetition/sm2_algorithm.dart';
import 'package:llanguage/core/spaced_repetition/spaced_repetition_service.dart';
import 'package:mocktail/mocktail.dart';

class MockSrDao extends Mock implements SrDao {}

void main() {
  late MockSrDao dao;
  late SpacedRepetitionService service;

  setUpAll(() {
    registerFallbackValue(DateTime.now());
    registerFallbackValue(UserVocabSrData(
      id: 0, vocabId: 0, easeFactor: 2.5, interval: 0,
      repetitions: 0, nextReviewAt: DateTime.now(), lastReviewAt: null,
    ));
  });

  setUp(() {
    dao = MockSrDao();
    service = SpacedRepetitionService(dao);
  });

  group('review', () {
    test('inits SR for new vocab and schedules review', () async {
      when(() => dao.getSrByVocab(1)).thenAnswer((_) async => null);
      when(() => dao.initSr(vocabId: any(named: 'vocabId'), now: any(named: 'now')))
          .thenAnswer((_) async => UserVocabSrData(
            id: 1, vocabId: 1, easeFactor: 2.5, interval: 0,
            repetitions: 0, nextReviewAt: DateTime.now(), lastReviewAt: null,
          ));
      when(() => dao.updateSr(
        any(),
        easeFactor: any(named: 'easeFactor'),
        interval: any(named: 'interval'),
        repetitions: any(named: 'repetitions'),
        nextReviewAt: any(named: 'nextReviewAt'),
        lastReviewAt: any(named: 'lastReviewAt'),
      )).thenAnswer((_) async => []);

      await service.review(1, 5);

      verify(() => dao.initSr(vocabId: 1, now: any(named: 'now'))).called(1);
      verify(() => dao.updateSr(
        1,
        easeFactor: any(named: 'easeFactor'),
        interval: any(named: 'interval'),
        repetitions: any(named: 'repetitions'),
        nextReviewAt: any(named: 'nextReviewAt'),
        lastReviewAt: any(named: 'lastReviewAt'),
      )).called(1);
    });

    test('updates existing SR and schedules next review', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      when(() => dao.getSrByVocab(1)).thenAnswer((_) async => UserVocabSrData(
        id: 1, vocabId: 1, easeFactor: 2.5, interval: 6,
        repetitions: 2, nextReviewAt: yesterday, lastReviewAt: null,
      ));
      when(() => dao.updateSr(
        any(),
        easeFactor: any(named: 'easeFactor'),
        interval: any(named: 'interval'),
        repetitions: any(named: 'repetitions'),
        nextReviewAt: any(named: 'nextReviewAt'),
        lastReviewAt: any(named: 'lastReviewAt'),
      )).thenAnswer((_) async => []);

      await service.review(1, 4);

      verify(() => dao.updateSr(
        1,
        easeFactor: greaterThan(2.5),
        interval: greaterThan(6),
        repetitions: 3,
        nextReviewAt: any(named: 'nextReviewAt'),
        lastReviewAt: any(named: 'lastReviewAt'),
      )).called(1);
    });
  });

  group('getDueReviews', () {
    test('delegates to dao', () async {
      when(() => dao.getDueReviews(upTo: any(named: 'upTo')))
          .thenAnswer((_) async => []);

      final due = await service.getDueReviews();
      expect(due, isEmpty);
    });
  });
}
