import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:llanguage/data/database/app_database.dart';
import 'package:llanguage/data/database/daos/course_dao.dart';
import 'package:llanguage/data/database/tables/all_tables.dart';

void main() {
  late AppDatabase database;
  late CourseDao dao;

  setUp(() {
    database = AppDatabase.forTest(NativeDatabase.memory());
    dao = CourseDao(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('CourseDao', () {
    test('createCourse inserts a course', () async {
      final now = DateTime.now();
      final course = await dao.createCourse(
        title: 'Indonesian Basics',
        sourceLang: 'en',
        targetLang: 'id',
        description: 'Learn Indonesian',
        level: 'beginner',
        createdAt: now,
        updatedAt: now,
      );
      expect(course.id, isNotNull);
      expect(course.title, equals('Indonesian Basics'));
    });

    test('getCourse retrieves by id', () async {
      final now = DateTime.now();
      final created = await dao.createCourse(title: 'Test', sourceLang: 'en', targetLang: 'id', description: 'd', level: 'beginner', createdAt: now, updatedAt: now);
      final retrieved = await dao.getCourse(created.id);
      expect(retrieved, isNotNull);
      expect(retrieved!.id, equals(created.id));
    });

    test('getAllCourses returns all courses', () async {
      final now = DateTime.now();
      await dao.createCourse(title: 'A', sourceLang: 'en', targetLang: 'id', description: 'd', level: 'beginner', createdAt: now, updatedAt: now);
      await dao.createCourse(title: 'B', sourceLang: 'en', targetLang: 'fr', description: 'd', level: 'intermediate', createdAt: now, updatedAt: now);
      final courses = await dao.getAllCourses();
      expect(courses.length, equals(2));
    });

    test('updateCourse modifies a course', () async {
      final now = DateTime.now();
      final created = await dao.createCourse(title: 'Original', sourceLang: 'en', targetLang: 'id', description: 'd', level: 'beginner', createdAt: now, updatedAt: now);
      final updated = await dao.updateCourse(created.id, title: 'Updated');
      expect(updated.first.title, equals('Updated'));
    });

    test('deleteCourse removes a course', () async {
      final now = DateTime.now();
      final created = await dao.createCourse(title: 'To Delete', sourceLang: 'en', targetLang: 'id', description: 'd', level: 'beginner', createdAt: now, updatedAt: now);
      await dao.deleteCourse(created.id);
      final retrieved = await dao.getCourse(created.id);
      expect(retrieved, isNull);
    });

    test('getCoursesByLevel filters correctly', () async {
      final now = DateTime.now();
      await dao.createCourse(title: 'A', sourceLang: 'en', targetLang: 'id', description: 'd', level: 'beginner', createdAt: now, updatedAt: now);
      await dao.createCourse(title: 'B', sourceLang: 'en', targetLang: 'fr', description: 'd', level: 'intermediate', createdAt: now, updatedAt: now);
      await dao.createCourse(title: 'C', sourceLang: 'en', targetLang: 'de', description: 'd', level: 'beginner', createdAt: now, updatedAt: now);
      final beginnerCourses = await dao.getCoursesByLevel('beginner');
      expect(beginnerCourses.length, equals(2));
    });
  });
}
