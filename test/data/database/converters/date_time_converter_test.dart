import 'package:flutter_test/flutter_test.dart';
import 'package:llanguage/data/database/converters/date_time_converter.dart';

void main() {
  late DateTimeConverter converter;

  setUp(() {
    converter = DateTimeConverter();
  });

  group('DateTimeConverter', () {
    test('maps DateTime to int (epoch millis)', () {
      final dt = DateTime(2024, 1, 15, 10, 30, 0);
      final result = converter.toSql(dt);
      expect(result, equals(dt.millisecondsSinceEpoch));
    });

    test('maps int to DateTime', () {
      final dt = DateTime(2024, 1, 15, 10, 30, 0);
      final millis = dt.millisecondsSinceEpoch;
      final result = converter.fromSql(millis);
      expect(result, equals(dt));
    });

    test('roundtrip preserves value', () {
      final original = DateTime(2025, 6, 1, 12, 0, 0);
      final sql = converter.toSql(original);
      final back = converter.fromSql(sql);
      expect(back, equals(original));
    });

    test('handles DateTime with microseconds', () {
      final dt = DateTime(2024, 12, 25, 8, 15, 30, 123, 456);
      final result = converter.toSql(dt);
      expect(result, equals(dt.millisecondsSinceEpoch));
    });
  });
}
