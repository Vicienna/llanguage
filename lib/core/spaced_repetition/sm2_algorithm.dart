class Sm2Result {
  final double easeFactor;
  final int interval;
  final int repetitions;

  const Sm2Result({
    required this.easeFactor,
    required this.interval,
    required this.repetitions,
  });
}

class Sm2Algorithm {
  static const double minEaseFactor = 1.3;

  Sm2Result calculate({
    required int quality,
    double currentEaseFactor = 2.5,
    int currentInterval = 0,
    int currentRepetitions = 0,
  }) {
    final clamped = quality.clamp(0, 5);

    if (clamped < 3) {
      return Sm2Result(
        easeFactor: currentEaseFactor,
        interval: 1,
        repetitions: 0,
      );
    }

    double newEase = currentEaseFactor + (0.1 - (5 - clamped) * (0.08 + (5 - clamped) * 0.02));
    if (newEase < minEaseFactor) newEase = minEaseFactor;

    final newReps = currentRepetitions + 1;
    int newInterval;

    switch (newReps) {
      case 1:
        newInterval = 1;
      case 2:
        newInterval = 6;
      default:
        newInterval = (currentInterval * newEase).round();
    }

    return Sm2Result(
      easeFactor: newEase,
      interval: newInterval,
      repetitions: newReps,
    );
  }
}
