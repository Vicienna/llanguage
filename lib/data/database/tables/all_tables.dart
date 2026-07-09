import 'package:drift/drift.dart';

class Courses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get sourceLang => text()();
  TextColumn get targetLang => text()();
  TextColumn get description => text()();
  TextColumn get level => text()();
  TextColumn? get thumbnailUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class Levels extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get courseId => integer().references(Courses, #id)();
  TextColumn get title => text()();
  IntColumn get orderIndex => integer()();
  TextColumn get description => text()();
}

class Units extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get levelId => integer().references(Levels, #id)();
  TextColumn get title => text()();
  IntColumn get orderIndex => integer()();
  TextColumn get description => text()();
}

class Lessons extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get unitId => integer().references(Units, #id)();
  TextColumn get title => text()();
  TextColumn get type => text()();
  IntColumn get orderIndex => integer()();
  TextColumn get contentJson => text()();
  BoolColumn get isPremium => boolean()();
}

class Vocab extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId => integer().references(Lessons, #id)();
  TextColumn get sourceWord => text()();
  TextColumn get targetWord => text()();
  TextColumn? get pronunciation => text().nullable()();
  TextColumn? get exampleSentence => text().nullable()();
  TextColumn? get imageUrl => text().nullable()();
  TextColumn? get partOfSpeech => text().nullable()();
}

class Grammar extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId => integer().references(Lessons, #id)();
  TextColumn get title => text()();
  TextColumn get explanation => text()();
  TextColumn get examples => text()();
}

class Dialogues extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId => integer().references(Lessons, #id)();
  TextColumn get title => text()();
  TextColumn get context => text()();
}

class DialogueLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dialogueId => integer().references(Dialogues, #id)();
  TextColumn get speaker => text()();
  TextColumn get sourceText => text()();
  TextColumn get targetText => text()();
  IntColumn get orderIndex => integer()();
}

class QuizQuestions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId => integer().references(Lessons, #id)();
  TextColumn get questionType => text()();
  TextColumn get question => text()();
  TextColumn get optionsJson => text()();
  TextColumn get correctAnswer => text()();
  TextColumn get explanation => text()();
}

class Stories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId => integer().references(Lessons, #id)();
  TextColumn get title => text()();
  TextColumn get sourceText => text()();
  TextColumn get targetText => text()();
  TextColumn get difficulty => text()();
}

class StoryPanels extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get storyId => integer().references(Stories, #id)();
  IntColumn get panelNumber => integer()();
  TextColumn? get imageUrl => text().nullable()();
  TextColumn get sourceText => text()();
  TextColumn get targetText => text()();
}

class StoryQuestions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get storyId => integer().references(Stories, #id)();
  TextColumn get question => text()();
  TextColumn get optionsJson => text()();
  TextColumn get correctAnswer => text()();
}

class UserLessonProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId => integer().references(Lessons, #id)();
  TextColumn get status => text()();
  IntColumn? get score => integer().nullable()();
  DateTimeColumn? get completedAt => dateTime().nullable()();
  IntColumn? get timeSpentSeconds => integer().nullable()();
}

class UserQuizAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get questionId => integer().references(QuizQuestions, #id)();
  TextColumn get userAnswer => text()();
  BoolColumn get isCorrect => boolean()();
  DateTimeColumn get attemptedAt => dateTime()();
}

class UserVocabSr extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vocabId => integer().references(Vocab, #id)();
  RealColumn get easeFactor => real()();
  IntColumn get interval => integer()();
  IntColumn get repetitions => integer()();
  DateTimeColumn get nextReviewAt => dateTime()();
  DateTimeColumn? get lastReviewAt => dateTime().nullable()();
}

class UserMistakes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vocabId => integer().references(Vocab, #id)();
  TextColumn get mistakeType => text()();
  TextColumn get mistakeText => text()();
  TextColumn get correction => text()();
  IntColumn get count => integer()();
  DateTimeColumn get createdAt => dateTime()();
}

class UserStreak extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get currentStreak => integer()();
  IntColumn get longestStreak => integer()();
  DateTimeColumn get lastActiveDate => dateTime()();
  IntColumn get frozenDays => integer()();
}

class UserStreakHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isActive => boolean()();
  IntColumn get streakAtThatTime => integer()();
}

class UserXpLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get amount => integer()();
  TextColumn get reason => text()();
  DateTimeColumn get createdAt => dateTime()();
}

class UserGems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get balance => integer()();
  IntColumn get lifetimeEarned => integer()();
}

class UserGemsLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get amount => integer()();
  TextColumn get reason => text()();
  TextColumn get type => text()();
  DateTimeColumn get createdAt => dateTime()();
}

class Achievements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn? get iconUrl => text().nullable()();
  TextColumn get category => text()();
  TextColumn get requirementJson => text()();
  IntColumn? get rewardXp => integer().nullable()();
  IntColumn? get rewardGems => integer().nullable()();
}

class UserAchievements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get achievementId => integer().references(Achievements, #id)();
  DateTimeColumn get unlockedAt => dateTime()();
  BoolColumn get isNew => boolean()();
}

class ChatSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get modelProvider => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class ChatMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(ChatSessions, #id)();
  TextColumn get role => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
}

class WritingHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sourceText => text()();
  TextColumn get correctedText => text()();
  TextColumn get language => text()();
  DateTimeColumn get createdAt => dateTime()();
}

class ReadingHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get url => text()();
  TextColumn get title => text()();
  TextColumn get sourceLanguage => text()();
  TextColumn get targetLanguage => text()();
  IntColumn get wordCount => integer()();
  DateTimeColumn get savedAt => dateTime()();
}

class VocabSuggestions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get word => text()();
  TextColumn get suggestions => text()();
  TextColumn get source => text()();
  DateTimeColumn get createdAt => dateTime()();
}

class CourseAccessTracking extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get courseId => integer().references(Courses, #id)();
  DateTimeColumn get lastAccessedAt => dateTime()();
  IntColumn get accessCount => integer()();
}

class AiCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get cacheKey => text().unique()();
  TextColumn get prompt => text()();
  TextColumn get response => text()();
  TextColumn get model => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime()();
}
