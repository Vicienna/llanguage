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
      final result = converter.toSql(map);
      expect(result, equals('{"key":"value","number":42}'));
    });

    test('maps JSON string to Map', () {
      final json = '{"key":"value","number":42}';
      final result = converter.fromSql(json);
      expect(result, equals({'key': 'value', 'number': 42}));
    });

    test('maps List to JSON string', () {
      final list = ['a', 'b', 'c'];
      final result = converter.toSql(list);
      expect(result, equals('["a","b","c"]'));
    });

    test('maps JSON string to List', () {
      final json = '["a","b","c"]';
      final result = converter.fromSql(json);
      expect(result, equals(['a', 'b', 'c']));
    });

    test('roundtrip preserves Map', () {
      final original = {'name': 'test', 'values': [1, 2, 3]};
      final sql = converter.toSql(original);
      final back = converter.fromSql(sql);
      expect(back, equals(original));
    });

    test('roundtrip preserves List', () {
      final original = ['x', 'y', 'z'];
      final sql = converter.toSql(original);
      final back = converter.fromSql(sql);
      expect(back, equals(original));
    });

    test('handles empty Map', () {
      final map = <String, dynamic>{};
      final result = converter.toSql(map);
      expect(result, equals('{}'));
    });

    test('handles empty List', () {
      final list = <dynamic>[];
      final result = converter.toSql(list);
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
      final sql = converter.toSql(nested);
      final back = converter.fromSql(sql);
      expect(back, equals(nested));
    });
  });
}
