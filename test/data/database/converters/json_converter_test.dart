import 'package:flutter_test/flutter_test.dart';
import 'package:llanguage/data/database/converters/json_converter.dart';

void main() {
  late JsonConverter converter;

  setUp(() {
    converter = JsonConverter();
  });

  group('JsonConverter', () {
    test('maps Map to JSON string', () {
      final map = {'key': 'value', 'number': 42};
      final result = converter.mapToSql(map);
      expect(result, equals('{"key":"value","number":42}'));
    });

    test('maps JSON string to Map', () {
      final json = '{"key":"value","number":42}';
      final result = converter.mapFromSql(json);
      expect(result, equals({'key': 'value', 'number': 42}));
    });

    test('maps List to JSON string', () {
      final list = ['a', 'b', 'c'];
      final result = converter.mapToSql(list);
      expect(result, equals('["a","b","c"]'));
    });

    test('maps JSON string to List', () {
      final json = '["a","b","c"]';
      final result = converter.mapFromSql(json);
      expect(result, equals(['a', 'b', 'c']));
    });

    test('roundtrip preserves Map', () {
      final original = {'name': 'test', 'values': [1, 2, 3]};
      final sql = converter.mapToSql(original);
      final back = converter.mapFromSql(sql);
      expect(back, equals(original));
    });

    test('roundtrip preserves List', () {
      final original = ['x', 'y', 'z'];
      final sql = converter.mapToSql(original);
      final back = converter.mapFromSql(sql);
      expect(back, equals(original));
    });

    test('handles empty Map', () {
      final map = <String, dynamic>{};
      final result = converter.mapToSql(map);
      expect(result, equals('{}'));
    });

    test('handles empty List', () {
      final list = <dynamic>[];
      final result = converter.mapToSql(list);
      expect(result, equals('[]'));
    });

    test('handles nested structures', () {
      final nested = {
        'level1': {
          'level2': [
            {'a': 1},
            {'b': 2},
          ],
        },
      };
      final sql = converter.mapToSql(nested);
      final back = converter.mapFromSql(sql);
      expect(back, equals(nested));
    });
  });
}
