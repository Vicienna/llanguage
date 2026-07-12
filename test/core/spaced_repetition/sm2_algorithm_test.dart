import 'package:flutter_test/flutter_test.dart';
import 'package:llanguage/core/spaced_repetition/sm2_algorithm.dart';

void main() {
  late Sm2Algorithm algorithm;

  setUp(() {
    algorithm = Sm2Algorithm();
  });

  group('calculate', () {
    test('quality 5 on first review sets interval to 1', () {
      final result = algorithm.calculate(quality: 5);
      expect(result.interval, equals(1));
      expect(result.repetitions, equals(1));
      expect(result.easeFactor, equals(2.6));
    });

    test('quality 4 on second review sets interval to 6', () {
      final first = algorithm.calculate(quality: 4);
      final second = algorithm.calculate(
        quality: 4,
        currentEaseFactor: first.easeFactor,
        currentInterval: first.interval,
        currentRepetitions: first.repetitions,
      );
      expect(second.interval, equals(6));
      expect(second.repetitions, equals(2));
    });

    test('quality 5 on third review multiplies interval by ease factor', () {
      final first = algorithm.calculate(quality: 5);
      final second = algorithm.calculate(
        quality: 5,
        currentEaseFactor: first.easeFactor,
        currentInterval: first.interval,
        currentRepetitions: first.repetitions,
      );
      final third = algorithm.calculate(
        quality: 5,
        currentEaseFactor: second.easeFactor,
        currentInterval: second.interval,
        currentRepetitions: second.repetitions,
      );
      expect(third.interval, greaterThan(6));
      expect(third.repetitions, equals(3));
    });

    test('quality < 3 resets repetitions to 0 and interval to 1', () {
      final first = algorithm.calculate(quality: 5);
      final second = algorithm.calculate(
        quality: 1,
        currentEaseFactor: first.easeFactor,
        currentInterval: first.interval,
        currentRepetitions: first.repetitions,
      );
      expect(second.repetitions, equals(0));
      expect(second.interval, equals(1));
    });

    test('clamps quality to 0-5 range', () {
      final result = algorithm.calculate(quality: 10);
      expect(result.repetitions, equals(1));
    });

    test('ease factor never goes below minimum', () {
      var ef = 2.5;
      var interval = 0;
      var reps = 0;
      for (int i = 0; i < 10; i++) {
        final result = algorithm.calculate(
          quality: 0,
          currentEaseFactor: ef,
          currentInterval: interval,
          currentRepetitions: reps,
        );
        ef = result.easeFactor;
        interval = result.interval;
        reps = result.repetitions;
      }
      expect(ef, greaterThanOrEqualTo(Sm2Algorithm.minEaseFactor));
    });
  });
}
