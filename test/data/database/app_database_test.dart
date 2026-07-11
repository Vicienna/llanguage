import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:llanguage/data/database/app_database.dart';
import 'package:llanguage/data/database/tables/all_tables.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTest(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  group('Database creation', () {
    test('database opens successfully', () {
      expect(database, isNotNull);
    });

    test('all tables exist', () async {
      final tables = await database.customSelect('SELECT name FROM sqlite_master WHERE type=\'table\' ORDER BY name').get();
      final tableNames = tables.map((r) => r.data['name'] as String).toSet();

      final expected = {
        'achievements',
        'ai_cache',
        'chat_messages',
        'chat_sessions',
        'course_access_tracking',
        'courses',
        'dialogue_lines',
        'dialogues',
        'grammar',
        'lessons',
        'levels',
        'quiz_questions',
        'reading_history',
        'stories',
        'story_panels',
        'story_questions',
        'units',
        'user_achievements',
        'user_gems',
        'user_gems_log',
        'user_lesson_progress',
        'user_mistakes',
        'user_quiz_attempts',
        'user_streak',
        'user_streak_history',
        'user_vocab_sr',
        'user_xp_log',
        'vocab',
        'vocab_suggestions',
        'writing_history',
      };

      for (final name in expected) {
        expect(tableNames, contains(name), reason: 'Table $name should exist');
      }
    });
  });

  group('Courses table CRUD', () {
    test('insert and read course', () async {
      final now = DateTime.now();
      final id = await database.into(database.courses).insert(CoursesCompanion.insert(
        title: 'Test Course',
        sourceLang: 'en',
        targetLang: 'id',
        description: 'A test course',
        level: 'beginner',
        thumbnailUrl: Value('https://example.com/thumb.png'),
        createdAt: now,
        updatedAt: now,
      ));
      final course = await (database.select(database.courses)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(course, isNotNull);
      expect(course!.title, equals('Test Course'));
      expect(course.sourceLang, equals('en'));
      expect(course.targetLang, equals('id'));
      expect(course.description, equals('A test course'));
      expect(course.level, equals('beginner'));
      expect(course.thumbnailUrl, equals('https://example.com/thumb.png'));
    });

    test('update course', () async {
      final now = DateTime.now();
      final id = await database.into(database.courses).insert(CoursesCompanion.insert(
        title: 'Original',
        sourceLang: 'en',
        targetLang: 'id',
        description: 'Original desc',
        level: 'beginner',
        createdAt: now,
        updatedAt: now,
      ));
      await (database.update(database.courses)..where((t) => t.id.equals(id))).write(CoursesCompanion(
        title: Value('Updated'),
      ));
      final course = await (database.select(database.courses)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(course!.title, equals('Updated'));
    });

    test('delete course', () async {
      final now = DateTime.now();
      await database.into(database.courses).insert(CoursesCompanion.insert(
        title: 'To Delete',
        sourceLang: 'en',
        targetLang: 'id',
        description: 'desc',
        level: 'beginner',
        createdAt: now,
        updatedAt: now,
      ));
      await database.delete(database.courses).go();
      final all = await database.select(database.courses).get();
      expect(all, isEmpty);
    });
  });

  group('Levels table CRUD', () {
    test('insert and read level with FK', () async {
      final now = DateTime.now();
      final courseId = await database.into(database.courses).insert(CoursesCompanion.insert(
        title: 'Course',
        sourceLang: 'en',
        targetLang: 'id',
        description: 'desc',
        level: 'beginner',
        createdAt: now,
        updatedAt: now,
      ));
      final id = await database.into(database.levels).insert(LevelsCompanion.insert(
        courseId: courseId,
        title: 'Level 1',
        orderIndex: 0,
        description: 'First level',
      ));
      final level = await (database.select(database.levels)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(level, isNotNull);
      expect(level!.title, equals('Level 1'));
      expect(level.courseId, equals(courseId));
      expect(level.orderIndex, equals(0));
    });
  });

  group('Units table CRUD', () {
    test('insert and read unit with FK', () async {
      final now = DateTime.now();
      final courseId = await database.into(database.courses).insert(CoursesCompanion.insert(title: 'C', sourceLang: 'en', targetLang: 'id', description: 'd', level: 'beginner', createdAt: now, updatedAt: now));
      final levelId = await database.into(database.levels).insert(LevelsCompanion.insert(courseId: courseId, title: 'L1', orderIndex: 0, description: 'd'));
      final unitId = await database.into(database.units).insert(UnitsCompanion.insert(levelId: levelId, title: 'Unit 1', orderIndex: 0, description: 'First unit'));
      final unit = await (database.select(database.units)..where((t) => t.id.equals(unitId))).getSingleOrNull();
      expect(unit!.title, equals('Unit 1'));
      expect(unit.levelId, equals(levelId));
    });
  });

  group('Lessons table CRUD', () {
    test('insert and read lesson with FK', () async {
      final now = DateTime.now();
      final courseId = await database.into(database.courses).insert(CoursesCompanion.insert(title: 'C', sourceLang: 'en', targetLang: 'id', description: 'd', level: 'beginner', createdAt: now, updatedAt: now));
      final levelId = await database.into(database.levels).insert(LevelsCompanion.insert(courseId: courseId, title: 'L1', orderIndex: 0, description: 'd'));
      final unitId = await database.into(database.units).insert(UnitsCompanion.insert(levelId: levelId, title: 'U1', orderIndex: 0, description: 'd'));
      final id = await database.into(database.lessons).insert(LessonsCompanion.insert(
        unitId: unitId,
        title: 'Lesson 1',
        type: 'vocab',
        orderIndex: 0,
        contentJson: '{}',
        isPremium: false,
      ));
      final lesson = await (database.select(database.lessons)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(lesson!.title, equals('Lesson 1'));
      expect(lesson.type, equals('vocab'));
      expect(lesson.unitId, equals(unitId));
      expect(lesson.isPremium, isFalse);
    });
  });

  group('Vocab table CRUD', () {
    test('insert and read vocab', () async {
      final now = DateTime.now();
      final courseId = await database.into(database.courses).insert(CoursesCompanion.insert(title: 'C', sourceLang: 'en', targetLang: 'id', description: 'd', level: 'beginner', createdAt: now, updatedAt: now));
      final levelId = await database.into(database.levels).insert(LevelsCompanion.insert(courseId: courseId, title: 'L1', orderIndex: 0, description: 'd'));
      final unitId = await database.into(database.units).insert(UnitsCompanion.insert(levelId: levelId, title: 'U1', orderIndex: 0, description: 'd'));
      final lessonId = await database.into(database.lessons).insert(LessonsCompanion.insert(unitId: unitId, title: 'L1', type: 'vocab', orderIndex: 0, orderIndex: 0, contentJson: '{}', isPremium: false));
      final id = await database.into(database.vocab).insert(VocabCompanion.insert(
        lessonId: lessonId,
        sourceWord: 'hello',
        targetWord: 'halo',
        pronunciation: Value('heh-low'),
        exampleSentence: Value('Hello world'),
        partOfSpeech: Value('interjection'),
      ));
      final word = await (database.select(database.vocab)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(word!.sourceWord, equals('hello'));
      expect(word.targetWord, equals('halo'));
      expect(word.lessonId, equals(lessonId));
    });
  });

  group('Grammar table CRUD', () {
    test('insert and read grammar', () async {
      final now = DateTime.now();
      final courseId = await database.into(database.courses).insert(CoursesCompanion.insert(title: 'C', sourceLang: 'en', targetLang: 'id', description: 'd', level: 'beginner', createdAt: now, updatedAt: now));
      final levelId = await database.into(database.levels).insert(LevelsCompanion.insert(courseId: courseId, title: 'L1', orderIndex: 0, description: 'd'));
      final unitId = await database.into(database.units).insert(UnitsCompanion.insert(levelId: levelId, title: 'U1', orderIndex: 0, description: 'd'));
      final lessonId = await database.into(database.lessons).insert(LessonsCompanion.insert(unitId: unitId, title: 'L1', type: 'grammar', orderIndex: 0, contentJson: '{}', isPremium: false));
      final id = await database.into(database.grammar).insert(GrammarCompanion.insert(
        lessonId: lessonId,
        title: 'Present Tense',
        explanation: 'How to use present tense',
        examples: 'I walk, you walk',
      ));
      final g = await (database.select(database.grammar)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(g!.title, equals('Present Tense'));
      expect(g.lessonId, equals(lessonId));
    });
  });

  group('Dialogues + DialogueLines CRUD', () {
    test('insert and read dialogue with lines', () async {
      final now = DateTime.now();
      final courseId = await database.into(database.courses).insert(CoursesCompanion.insert(title: 'C', sourceLang: 'en', targetLang: 'id', description: 'd', level: 'beginner', createdAt: now, updatedAt: now));
      final levelId = await database.into(database.levels).insert(LevelsCompanion.insert(courseId: courseId, title: 'L1', orderIndex: 0, description: 'd'));
      final unitId = await database.into(database.units).insert(UnitsCompanion.insert(levelId: levelId, title: 'U1', orderIndex: 0, description: 'd'));
      final lessonId = await database.into(database.lessons).insert(LessonsCompanion.insert(unitId: unitId, title: 'L1', type: 'dialogue', orderIndex: 0, contentJson: '{}', isPremium: false));
      final dialogueId = await database.into(database.dialogues).insert(DialoguesCompanion.insert(
        lessonId: lessonId,
        title: 'At the store',
        context: 'Buying groceries',
      ));
      final lineId = await database.into(database.dialogueLines).insert(DialogueLinesCompanion.insert(
        dialogueId: dialogueId,
        speaker: 'A',
        sourceText: 'How much?',
        targetText: 'Berapa?',
        orderIndex: 0,
      ));
      final line = await (database.select(database.dialogueLines)..where((t) => t.id.equals(lineId))).getSingleOrNull();
      expect(line!.speaker, equals('A'));
      expect(line.sourceText, equals('How much?'));
      expect(line.dialogueId, equals(dialogueId));
    });
  });

  group('QuizQuestions table CRUD', () {
    test('insert and read quiz question', () async {
      final now = DateTime.now();
      final courseId = await database.into(database.courses).insert(CoursesCompanion.insert(title: 'C', sourceLang: 'en', targetLang: 'id', description: 'd', level: 'beginner', createdAt: now, updatedAt: now));
      final levelId = await database.into(database.levels).insert(LevelsCompanion.insert(courseId: courseId, title: 'L1', orderIndex: 0, description: 'd'));
      final unitId = await database.into(database.units).insert(UnitsCompanion.insert(levelId: levelId, title: 'U1', orderIndex: 0, description: 'd'));
      final lessonId = await database.into(database.lessons).insert(LessonsCompanion.insert(unitId: unitId, title: 'L1', type: 'quiz', orderIndex: 0, contentJson: '{}', isPremium: false));
      final id = await database.into(database.quizQuestions).insert(QuizQuestionsCompanion.insert(
        lessonId: lessonId,
        questionType: 'mcq',
        question: 'What is X?',
        optionsJson: '["A","B","C","D"]',
        correctAnswer: 'A',
        explanation: 'Because...',
      ));
      final q = await (database.select(database.quizQuestions)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(q!.questionType, equals('mcq'));
      expect(q.question, equals('What is X?'));
      expect(q.correctAnswer, equals('A'));
    });
  });

  group('Stories + StoryPanels + StoryQuestions CRUD', () {
    test('insert and read story with panels and questions', () async {
      final now = DateTime.now();
      final courseId = await database.into(database.courses).insert(CoursesCompanion.insert(title: 'C', sourceLang: 'en', targetLang: 'id', description: 'd', level: 'beginner', createdAt: now, updatedAt: now));
      final levelId = await database.into(database.levels).insert(LevelsCompanion.insert(courseId: courseId, title: 'L1', orderIndex: 0, description: 'd'));
      final unitId = await database.into(database.units).insert(UnitsCompanion.insert(levelId: levelId, title: 'U1', orderIndex: 0, description: 'd'));
      final lessonId = await database.into(database.lessons).insert(LessonsCompanion.insert(unitId: unitId, title: 'L1', type: 'story', orderIndex: 0, contentJson: '{}', isPremium: false));
      final storyId = await database.into(database.stories).insert(StoriesCompanion.insert(
        lessonId: lessonId,
        title: 'The Journey',
        sourceText: 'Once upon a time',
        targetText: 'Dahulu kala',
        difficulty: 'easy',
      ));
      final panelId = await database.into(database.storyPanels).insert(StoryPanelsCompanion.insert(
        storyId: storyId,
        panelNumber: 1,
        imageUrl: Value('https://example.com/panel1.png'),
        sourceText: 'Once upon a time',
        targetText: 'Dahulu kala',
      ));
      final sqId = await database.into(database.storyQuestions).insert(StoryQuestionsCompanion.insert(
        storyId: storyId,
        question: 'What happened?',
        optionsJson: '["A","B","C"]',
        correctAnswer: 'A',
      ));
      final story = await (database.select(database.stories)..where((t) => t.id.equals(storyId))).getSingleOrNull();
      expect(story!.title, equals('The Journey'));
      expect(story.difficulty, equals('easy'));
      final panel = await (database.select(database.storyPanels)..where((t) => t.id.equals(panelId))).getSingleOrNull();
      expect(panel!.panelNumber, equals(1));
      final sq = await (database.select(database.storyQuestions)..where((t) => t.id.equals(sqId))).getSingleOrNull();
      expect(sq!.correctAnswer, equals('A'));
    });
  });

  group('User progress tables CRUD', () {
    test('insert and read user_lesson_progress', () async {
      final now = DateTime.now();
      final courseId = await database.into(database.courses).insert(CoursesCompanion.insert(title: 'C', sourceLang: 'en', targetLang: 'id', description: 'd', level: 'beginner', createdAt: now, updatedAt: now));
      final levelId = await database.into(database.levels).insert(LevelsCompanion.insert(courseId: courseId, title: 'L1', orderIndex: 0, description: 'd'));
      final unitId = await database.into(database.units).insert(UnitsCompanion.insert(levelId: levelId, title: 'U1', orderIndex: 0, description: 'd'));
      final lessonId = await database.into(database.lessons).insert(LessonsCompanion.insert(unitId: unitId, title: 'L1', type: 'vocab', orderIndex: 0, contentJson: '{}', isPremium: false));
      final id = await database.into(database.userLessonProgress).insert(UserLessonProgressCompanion.insert(
        lessonId: lessonId,
        status: 'in_progress',
        score: Value(80),
        timeSpentSeconds: Value(120),
      ));
      final prog = await (database.select(database.userLessonProgress)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(prog!.status, equals('in_progress'));
      expect(prog.score, equals(80));
    });

    test('insert and read user_quiz_attempts', () async {
      final now = DateTime.now();
      final courseId = await database.into(database.courses).insert(CoursesCompanion.insert(title: 'C', sourceLang: 'en', targetLang: 'id', description: 'd', level: 'beginner', createdAt: now, updatedAt: now));
      final levelId = await database.into(database.levels).insert(LevelsCompanion.insert(courseId: courseId, title: 'L1', orderIndex: 0, description: 'd'));
      final unitId = await database.into(database.units).insert(UnitsCompanion.insert(levelId: levelId, title: 'U1', orderIndex: 0, description: 'd'));
      final lessonId = await database.into(database.lessons).insert(LessonsCompanion.insert(unitId: unitId, title: 'L1', type: 'quiz', orderIndex: 0, contentJson: '{}', isPremium: false));
      final qId = await database.into(database.quizQuestions).insert(QuizQuestionsCompanion.insert(lessonId: lessonId, questionType: 'mcq', question: 'Q?', optionsJson: '[]', correctAnswer: 'A', explanation: 'e'));
      final id = await database.into(database.userQuizAttempts).insert(UserQuizAttemptsCompanion.insert(
        questionId: qId,
        userAnswer: 'A',
        isCorrect: true,
        attemptedAt: now,
      ));
      final att = await (database.select(database.userQuizAttempts)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(att!.isCorrect, isTrue);
      expect(att.userAnswer, equals('A'));
    });
  });

  group('User vocab SR table CRUD', () {
    test('insert and read user_vocab_sr', () async {
      final now = DateTime.now();
      final courseId = await database.into(database.courses).insert(CoursesCompanion.insert(title: 'C', sourceLang: 'en', targetLang: 'id', description: 'd', level: 'beginner', createdAt: now, updatedAt: now));
      final levelId = await database.into(database.levels).insert(LevelsCompanion.insert(courseId: courseId, title: 'L1', orderIndex: 0, description: 'd'));
      final unitId = await database.into(database.units).insert(UnitsCompanion.insert(levelId: levelId, title: 'U1', orderIndex: 0, description: 'd'));
      final lessonId = await database.into(database.lessons).insert(LessonsCompanion.insert(unitId: unitId, title: 'L1', type: 'vocab', orderIndex: 0, contentJson: '{}', isPremium: false));
      final vocabId = await database.into(database.vocab).insert(VocabCompanion.insert(lessonId: lessonId, sourceWord: 'hello', targetWord: 'halo', partOfSpeech: Value('n')));
      final id = await database.into(database.userVocabSr).insert(UserVocabSrCompanion.insert(
        vocabId: vocabId,
        easeFactor: 2.5,
        interval: 0,
        repetitions: 0,
        nextReviewAt: now,
      ));
      final sr = await (database.select(database.userVocabSr)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(sr!.easeFactor, equals(2.5));
      expect(sr.repetitions, equals(0));
    });
  });

  group('User mistakes table CRUD', () {
    test('insert and read user_mistakes', () async {
      final now = DateTime.now();
      final courseId = await database.into(database.courses).insert(CoursesCompanion.insert(title: 'C', sourceLang: 'en', targetLang: 'id', description: 'd', level: 'beginner', createdAt: now, updatedAt: now));
      final levelId = await database.into(database.levels).insert(LevelsCompanion.insert(courseId: courseId, title: 'L1', orderIndex: 0, description: 'd'));
      final unitId = await database.into(database.units).insert(UnitsCompanion.insert(levelId: levelId, title: 'U1', orderIndex: 0, description: 'd'));
      final lessonId = await database.into(database.lessons).insert(LessonsCompanion.insert(unitId: unitId, title: 'L1', type: 'vocab', orderIndex: 0, contentJson: '{}', isPremium: false));
      final vocabId = await database.into(database.vocab).insert(VocabCompanion.insert(lessonId: lessonId, sourceWord: 'hello', targetWord: 'halo', partOfSpeech: Value('n')));
      final id = await database.into(database.userMistakes).insert(UserMistakesCompanion.insert(
        vocabId: vocabId,
        mistakeType: 'spelling',
        mistakeText: 'helo',
        correction: 'hello',
        count: 1,
        createdAt: now,
      ));
      final m = await (database.select(database.userMistakes)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(m!.mistakeType, equals('spelling'));
      expect(m.mistakeText, equals('helo'));
    });
  });

  group('User streak tables CRUD', () {
    test('insert and read user_streak (single row)', () async {
      final now = DateTime.now();
      final id = await database.into(database.userStreak).insert(UserStreakCompanion.insert(
        currentStreak: 5,
        longestStreak: 10,
        lastActiveDate: now,
        frozenDays: 2,
      ));
      final s = await (database.select(database.userStreak)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(s!.currentStreak, equals(5));
      expect(s.longestStreak, equals(10));
    });

    test('insert and read user_streak_history', () async {
      final now = DateTime.now();
      final id = await database.into(database.userStreakHistory).insert(UserStreakHistoryCompanion.insert(
        date: now,
        isActive: true,
        streakAtThatTime: 5,
      ));
      final h = await (database.select(database.userStreakHistory)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(h!.isActive, isTrue);
      expect(h.streakAtThatTime, equals(5));
    });
  });

  group('User XP/Gems tables CRUD', () {
    test('insert and read user_xp_log', () async {
      final now = DateTime.now();
      final id = await database.into(database.userXpLog).insert(UserXpLogCompanion.insert(
        amount: 50,
        reason: 'completed_lesson',
        createdAt: now,
      ));
      final xp = await (database.select(database.userXpLog)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(xp!.amount, equals(50));
    });

    test('insert and read user_gems (single row)', () async {
      final id = await database.into(database.userGems).insert(UserGemsCompanion.insert(
        balance: 100,
        lifetimeEarned: 500,
      ));
      final gems = await (database.select(database.userGems)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(gems!.balance, equals(100));
    });

    test('insert and read user_gems_log', () async {
      final now = DateTime.now();
      final id = await database.into(database.userGemsLog).insert(UserGemsLogCompanion.insert(
        amount: 10,
        reason: 'daily_reward',
        type: 'earn',
        createdAt: now,
      ));
      final log = await (database.select(database.userGemsLog)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(log!.amount, equals(10));
      expect(log.type, equals('earn'));
    });
  });

  group('Achievements tables CRUD', () {
    test('insert and read achievement', () async {
      final id = await database.into(database.achievements).insert(AchievementsCompanion.insert(
        title: 'First Lesson',
        description: 'Complete first lesson',
        iconUrl: Value('https://example.com/icon.png'),
        category: 'milestone',
        requirementJson: '{"type":"complete_lessons","count":1}',
        rewardXp: Value(100),
        rewardGems: Value(10),
      ));
      final a = await (database.select(database.achievements)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(a!.title, equals('First Lesson'));
      expect(a.category, equals('milestone'));
    });

    test('insert and read user_achievements', () async {
      final now = DateTime.now();
      final achId = await database.into(database.achievements).insert(AchievementsCompanion.insert(
        title: 'A', description: 'D', category: 'misc', requirementJson: '{}',
      ));
      final id = await database.into(database.userAchievements).insert(UserAchievementsCompanion.insert(
        achievementId: achId,
        unlockedAt: now,
        isNew: true,
      ));
      final ua = await (database.select(database.userAchievements)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(ua!.isNew, isTrue);
      expect(ua.achievementId, equals(achId));
    });
  });

  group('Chat tables CRUD', () {
    test('insert and read chat session with messages', () async {
      final now = DateTime.now();
      final sessionId = await database.into(database.chatSessions).insert(ChatSessionsCompanion.insert(
        title: 'Chat 1',
        modelProvider: 'gpt-4',
        createdAt: now,
        updatedAt: now,
      ));
      final msgId = await database.into(database.chatMessages).insert(ChatMessagesCompanion.insert(
        sessionId: sessionId,
        role: 'user',
        content: 'Hello!',
        createdAt: now,
      ));
      final session = await (database.select(database.chatSessions)..where((t) => t.id.equals(sessionId))).getSingleOrNull();
      expect(session!.title, equals('Chat 1'));
      final msg = await (database.select(database.chatMessages)..where((t) => t.id.equals(msgId))).getSingleOrNull();
      expect(msg!.role, equals('user'));
      expect(msg.content, equals('Hello!'));
    });
  });

  group('Writing/Reading history CRUD', () {
    test('insert and read writing_history', () async {
      final now = DateTime.now();
      final id = await database.into(database.writingHistory).insert(WritingHistoryCompanion.insert(
        sourceText: 'I am go',
        correctedText: 'I am going',
        language: 'en',
        createdAt: now,
      ));
      final w = await (database.select(database.writingHistory)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(w!.sourceText, equals('I am go'));
      expect(w.correctedText, equals('I am going'));
    });

    test('insert and read reading_history', () async {
      final now = DateTime.now();
      final id = await database.into(database.readingHistory).insert(ReadingHistoryCompanion.insert(
        url: 'https://example.com/article',
        title: 'Article',
        sourceLanguage: 'en',
        targetLanguage: 'id',
        wordCount: 500,
        savedAt: now,
      ));
      final r = await (database.select(database.readingHistory)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(r!.url, equals('https://example.com/article'));
      expect(r.wordCount, equals(500));
    });
  });

  group('Vocab suggestions CRUD', () {
    test('insert and read vocab_suggestions', () async {
      final now = DateTime.now();
      final id = await database.into(database.vocabSuggestions).insert(VocabSuggestionsCompanion.insert(
        word: 'serendipity',
        suggestions: '["keberuntungan","kebetulan"]',
        source: 'user',
        createdAt: now,
      ));
      final v = await (database.select(database.vocabSuggestions)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(v!.word, equals('serendipity'));
      expect(v.source, equals('user'));
    });
  });

  group('Course access tracking CRUD', () {
    test('insert and read course_access_tracking', () async {
      final now = DateTime.now();
      final courseId = await database.into(database.courses).insert(CoursesCompanion.insert(title: 'C', sourceLang: 'en', targetLang: 'id', description: 'd', level: 'beginner', createdAt: now, updatedAt: now));
      final id = await database.into(database.courseAccessTracking).insert(CourseAccessTrackingCompanion.insert(
        courseId: courseId,
        lastAccessedAt: now,
        accessCount: 1,
      ));
      final cat = await (database.select(database.courseAccessTracking)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(cat!.accessCount, equals(1));
      expect(cat.courseId, equals(courseId));
    });
  });

  group('AI cache CRUD', () {
    test('insert and read ai_cache', () async {
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 1));
      final id = await database.into(database.aiCache).insert(AiCacheCompanion.insert(
        cacheKey: 'translate:hello:en:id',
        prompt: 'Translate hello to Indonesian',
        response: 'Halo',
        model: 'gpt-4',
        createdAt: now,
        expiresAt: expiresAt,
      ));
      final cache = await (database.select(database.aiCache)..where((t) => t.id.equals(id))).getSingleOrNull();
      expect(cache!.cacheKey, equals('translate:hello:en:id'));
      expect(cache.response, equals('Halo'));
    });

    test('cacheKey is unique', () async {
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 1));
      await database.into(database.aiCache).insert(AiCacheCompanion.insert(
        cacheKey: 'unique-key',
        prompt: 'prompt',
        response: 'response',
        model: 'gpt-4',
        createdAt: now,
        expiresAt: expiresAt,
      ));
      expect(
        () => database.into(database.aiCache).insert(AiCacheCompanion.insert(
          cacheKey: 'unique-key',
          prompt: 'prompt2',
          response: 'response2',
          model: 'gpt-4',
          createdAt: now,
          expiresAt: expiresAt,
        )),
        throwsA(isA<DriftWrappedException>()),
      );
    });
  });
}
