import 'package:drift/drift.dart';

class DateTimeConverter extends TypeConverter<DateTime, int> {
  const DateTimeConverter();

  @override
  DateTime mapFromSql(int fromDb) => DateTime.fromMillisecondsSinceEpoch(fromDb);

  @override
  int mapToSql(DateTime value) => value.millisecondsSinceEpoch;
}
