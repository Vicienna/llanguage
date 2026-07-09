import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'tables/all_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Courses,
    Levels,
    Units,
    Lessons,
    Vocab,
    Grammar,
    Dialogues,
    DialogueLines,
    QuizQuestions,
    Stories,
    StoryPanels,
    StoryQuestions,
    UserLessonProgress,
    UserQuizAttempts,
    UserVocabSr,
    UserMistakes,
    UserStreak,
    UserStreakHistory,
    UserXpLog,
    UserGems,
    UserGemsLog,
    Achievements,
    UserAchievements,
    ChatSessions,
    ChatMessages,
    WritingHistory,
    ReadingHistory,
    VocabSuggestions,
    CourseAccessTracking,
    AiCache,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTest(QueryExecutor executor) : super(executor);

  static AppDatabase? _instance;

  static AppDatabase get instance {
    _instance ??= AppDatabase();
    return _instance!;
  }

  static void resetInstance() {
    _instance = null;
  }

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'llanguage.db'));
    return NativeDatabase(file);
  });
}
