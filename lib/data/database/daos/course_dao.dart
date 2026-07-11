import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/all_tables.dart';

part 'course_dao.g.dart';

@DriftAccessor(tables: [Courses, Levels, Units, Lessons, CourseAccessTracking])
class CourseDao extends DatabaseAccessor<AppDatabase> with _$CourseDaoMixin {
  final AppDatabase db;

  CourseDao(this.db) : super(db);

  Future<Course> createCourse({
    required String title,
    required String sourceLang,
    required String targetLang,
    required String description,
    required String level,
    String? thumbnailUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) =>
      db.into(db.courses).insertReturning(CoursesCompanion.insert(
        title: title,
        sourceLang: sourceLang,
        targetLang: targetLang,
        description: description,
        level: level,
        thumbnailUrl: Value(thumbnailUrl),
        createdAt: createdAt,
        updatedAt: updatedAt,
      ));

  Future<Course?> getCourse(int id) =>
      (db.select(db.courses)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Course>> getAllCourses() => db.select(db.courses).get();

  Future<List<Course>> updateCourse(
    int id, {
    String? title,
    String? sourceLang,
    String? targetLang,
    String? description,
    String? level,
    String? thumbnailUrl,
    DateTime? updatedAt,
  }) =>
      (db.update(db.courses)..where((t) => t.id.equals(id))).writeReturning(CoursesCompanion(
        title: title != null ? Value(title!) : Value.absent(),
        sourceLang: sourceLang != null ? Value(sourceLang!) : Value.absent(),
        targetLang: targetLang != null ? Value(targetLang!) : Value.absent(),
        description: description != null ? Value(description!) : Value.absent(),
        level: level != null ? Value(level!) : Value.absent(),
        thumbnailUrl: thumbnailUrl != null ? Value(thumbnailUrl) : Value.absent(),
        updatedAt: updatedAt != null ? Value(updatedAt!) : Value.absent(),
      ));

  Future<int> deleteCourse(int id) =>
      (db.delete(db.courses)..where((t) => t.id.equals(id))).go();

  Future<List<Course>> getCoursesByLevel(String level) =>
      (db.select(db.courses)..where((t) => t.level.equals(level))).get();
}
