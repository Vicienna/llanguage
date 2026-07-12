import '../../data/database/daos/sr_dao.dart';
import 'sm2_algorithm.dart';

class SpacedRepetitionService {
  final SrDao _dao;
  final Sm2Algorithm _algorithm;

  SpacedRepetitionService(this._dao, {Sm2Algorithm? algorithm})
      : _algorithm = algorithm ?? Sm2Algorithm();

  Future<void> review(int vocabId, int quality) async {
    final now = DateTime.now();
    var sr = await _dao.getSrByVocab(vocabId);
    if (sr == null) {
      sr = await _dao.initSr(vocabId: vocabId, now: now);
    }

    final result = _algorithm.calculate(
      quality: quality,
      currentEaseFactor: sr.easeFactor,
      currentInterval: sr.interval,
      currentRepetitions: sr.repetitions,
    );

    final nextReview = now.add(Duration(days: result.interval));
    await _dao.updateSr(
      vocabId,
      easeFactor: result.easeFactor,
      interval: result.interval,
      repetitions: result.repetitions,
      nextReviewAt: nextReview,
      lastReviewAt: now,
    );
  }

  Future<List<UserVocabSrData>> getDueReviews() {
    return _dao.getDueReviews(upTo: DateTime.now());
  }
}
