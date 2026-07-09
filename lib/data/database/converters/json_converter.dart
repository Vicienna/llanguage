import 'dart:convert';
import 'package:drift/drift.dart';

class JsonConverter extends TypeConverter<dynamic, String> {
  const JsonConverter();

  @override
  dynamic mapFromSql(String fromDb) => jsonDecode(fromDb);

  @override
  String mapToSql(dynamic value) => jsonEncode(value);
}
