# AGENT.md — LLanguage Project Agent Manual

**Version:** 1.0.0
**Last Updated:** 2026-07-08
**Total Features:** 51
**Status:** Project Initialization

---

## 📌 IDENTITAS PROYEK

| Key | Value |
|---|---|
| **Nama** | LLanguage |
| **Tech Stack** | Flutter 3.24.x + Dart 3.x + Drift (SQLite) + Riverpod + GoRouter |
| **Target Platform** | Android 8.0+ (API 26+) |
| **Database** | 100% lokal SQLite (Drift). NO Firebase, Supabase, MongoDB, atau cloud DB apapun |
| **AI Provider** | OpenAI-compatible (BYOK: OpenRouter, Groq, xAI, DeepSeek, Ollama, Custom) |
| **API Gratis** | DuckDuckGo Instant Answer API (no API key, no rate limit ketat) |
| **Development** | 100% dari HP (ACode/CodeStudio) |
| **Build** | GitHub Actions (trigger: push tag `v*`) |
| **Storage** | ~20-40 MB di HP (hanya source code + editor) |
| **Repo** | `github.com/{user}/llanguage` |

---

## 🚀 PERINTAH UTAMA

### Build & Run (hanya jalan di GitHub Actions, bukan di HP)

```bash
# Install dependencies
flutter pub get

# Generate Drift + Freezed code
dart run build_runner build --delete-conflicting-outputs

# Analyze code
flutter analyze

# Build APK
flutter build apk --debug
flutter build apk --release --split-per-abi

# Run tests
flutter test
```

### Git Flow

```bash
# Push kode (tidak trigger build)
git add .
git commit -m "feat: description"
git push origin main

# Push tag (trigger build + release APK)
git tag v1.0.0
git push origin v1.0.0
```

---

## 📁 STRUKTUR FOLDER LENGKAP

```
llanguage/
├── lib/
│   ├── main.dart                          # Entry point
│   ├── app.dart                           # MaterialApp + router + theme
│   ├── bootstrap.dart                     # Initialization
│   │
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_theme.dart             # Light + dark theme data
│   │   │   ├── app_colors.dart            # Color constants
│   │   │   ├── app_typography.dart        # Text styles
│   │   │   └── app_decoration.dart        # Borders, shadows, radius
│   │   ├── constants/
│   │   │   ├── app_constants.dart         # App-wide constants
│   │   │   ├── api_constants.dart         # API endpoints, defaults
│   │   │   └── ui_constants.dart          # Spacing, sizes, durations
│   │   ├── utils/
│   │   │   ├── logger.dart                # Logging utility
│   │   │   ├── validators.dart            # Input validators
│   │   │   ├── date_utils.dart            # Date formatting
│   │   │   └── debouncer.dart             # Debounce utility
│   │   └── extensions/
│   │       ├── string_ext.dart
│   │       ├── context_ext.dart
│   │       └── datetime_ext.dart
│   │
│   ├── data/
│   │   ├── database/
│   │   │   ├── app_database.dart          # Drift database definition
│   │   │   ├── app_database.g.dart        # Generated
│   │   │   ├── converters/
│   │   │   │   ├── datetime_converter.dart
│   │   │   │   └── json_converter.dart
│   │   │   ├── tables/
│   │   │   │   ├── courses.dart
│   │   │   │   ├── levels.dart
│   │   │   │   ├── units.dart
│   │   │   │   ├── lessons.dart
│   │   │   │   ├── vocab.dart
│   │   │   │   ├── vocab_fts.dart
│   │   │   │   ├── grammar.dart
│   │   │   │   ├── dialogues.dart
│   │   │   │   ├── dialogue_lines.dart
│   │   │   │   ├── quiz_questions.dart
│   │   │   │   ├── stories.dart
│   │   │   │   ├── story_panels.dart
│   │   │   │   ├── story_questions.dart
│   │   │   │   ├── user_lesson_progress.dart
│   │   │   │   ├── user_quiz_attempts.dart
│   │   │   │   ├── user_vocab_sr.dart
│   │   │   │   ├── user_mistakes.dart
│   │   │   │   ├── user_streak.dart
│   │   │   │   ├── user_streak_history.dart
│   │   │   │   ├── user_xp_log.dart
│   │   │   │   ├── user_gems.dart
│   │   │   │   ├── user_gems_log.dart
│   │   │   │   ├── achievements.dart
│   │   │   │   ├── user_achievements.dart
│   │   │   │   ├── chat_sessions.dart
│   │   │   │   ├── chat_messages.dart
│   │   │   │   ├── writing_history.dart
│   │   │   │   ├── reading_history.dart
│   │   │   │   ├── vocab_suggestions.dart
│   │   │   │   ├── course_access_tracking.dart
│   │   │   │   └── ai_cache.dart
│   │   │   └── daos/
│   │   │       ├── course_dao.dart
│   │   │       ├── vocab_dao.dart
│   │   │       ├── progress_dao.dart
│   │   │       ├── gamification_dao.dart
│   │   │       ├── sr_dao.dart
│   │   │       ├── chat_dao.dart
│   │   │       ├── mistake_dao.dart
│   │   │       └── cache_dao.dart
│   │   ├── models/
│   │   │   ├── translation_result.dart
│   │   │   ├── word_detail.dart
│   │   │   ├── lesson_content.dart
│   │   │   ├── quiz_question.dart
│   │   │   ├── sr_stats.dart
│   │   │   └── weekly_report.dart
│   │   └── repositories/
│   │       ├── course_repository.dart
│   │       ├── vocab_repository.dart
│   │       ├── lesson_repository.dart
│   │       ├── progress_repository.dart
│   │       ├── gamification_repository.dart
│   │       ├── sr_repository.dart
│   │       ├── chat_repository.dart
│   │       ├── translation_repository.dart
│   │       └── settings_repository.dart
│   │
│   ├── services/
│   │   ├── ai/
│   │   │   ├── ai_provider.dart           # Abstract class
│   │   │   ├── openai_adapter.dart        # Universal OpenAI-compatible
│   │   │   ├── openrouter_provider.dart   # OpenRouter preset
│   │   │   ├── groq_provider.dart         # Groq preset
│   │   │   ├── xai_provider.dart          # xAI preset
│   │   │   ├── deepseek_provider.dart     # DeepSeek preset
│   │   │   ├── ollama_provider.dart       # Ollama preset
│   │   │   └── custom_provider.dart       # Custom URL+model
│   │   ├── duckduckgo/
│   │   │   ├── duckduckgo_service.dart    # Main DDG service
│   │   │   └── models/
│   │   │       ├── ddg_instant_result.dart
│   │   │       ├── ddg_article.dart
│   │   │       └── ddg_related_topic.dart
│   │   ├── tts/
│   │   │   ├── tts_service.dart
│   │   │   └── tts_cache_manager.dart
│   │   ├── notification/
│   │   │   ├── notification_service.dart
│   │   │   └── scheduled_tasks.dart
│   │   ├── backup/
│   │   │   ├── backup_service.dart
│   │   │   └── export_service.dart
│   │   ├── voice/
│   │   │   └── voice_command_service.dart
│   │   ├── translation_service.dart       # Orchestrator: DDG → AI
│   │   ├── course_generator_service.dart  # AI generate konten
│   │   ├── course_cache_manager.dart      # LRU eviction logic
│   │   ├── gamification_service.dart      # XP, streak, achievement
│   │   ├── sr_service.dart                # Spaced Repetition SM-2
│   │   ├── mistake_analyzer.dart          # Mistake journal logic
│   │   └── weekly_report_service.dart     # Aggregator
│   │
│   ├── features/
│   │   ├── splash/
│   │   │   ├── splash_page.dart
│   │   │   └── splash_provider.dart
│   │   ├── onboarding/
│   │   │   ├── onboarding_page.dart
│   │   │   ├── widgets/
│   │   │   └── onboarding_provider.dart
│   │   ├── home/
│   │   │   ├── home_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── learning_path.dart
│   │   │   │   ├── streak_indicator.dart
│   │   │   │   ├── daily_reward_widget.dart
│   │   │   │   └── quick_review_card.dart
│   │   │   └── home_provider.dart
│   │   ├── translator/
│   │   │   ├── translator_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── language_selector.dart
│   │   │   │   ├── translation_input.dart
│   │   │   │   ├── translation_output.dart
│   │   │   │   ├── tappable_text.dart
│   │   │   │   ├── quick_definition_card.dart
│   │   │   │   └── word_detail_sheet.dart
│   │   │   └── translator_provider.dart
│   │   ├── course/
│   │   │   ├── course_overview_page.dart
│   │   │   ├── course_creation_page.dart
│   │   │   ├── level_select_page.dart
│   │   │   ├── unit_select_page.dart
│   │   │   └── widgets/
│   │   │       ├── course_card.dart
│   │   │       ├── level_node.dart
│   │   │       └── unit_list.dart
│   │   ├── lesson/
│   │   │   ├── lesson_player_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── flashcard_slide.dart
│   │   │   │   ├── dialogue_bubble.dart
│   │   │   │   ├── grammar_card.dart
│   │   │   │   ├── story_panel.dart
│   │   │   │   └── lesson_complete_screen.dart
│   │   │   └── lesson_provider.dart
│   │   ├── quiz/
│   │   │   ├── quiz_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── mcq_widget.dart
│   │   │   │   ├── typing_widget.dart
│   │   │   │   ├── matching_widget.dart
│   │   │   │   ├── ordering_widget.dart
│   │   │   │   ├── listening_widget.dart
│   │   │   │   └── quiz_result_screen.dart
│   │   │   └── quiz_provider.dart
│   │   ├── review/
│   │   │   ├── review_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── sr_card.dart
│   │   │   │   └── review_summary.dart
│   │   │   └── review_provider.dart
│   │   ├── chat/
│   │   │   ├── chat_list_page.dart
│   │   │   ├── chat_detail_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── chat_bubble.dart
│   │   │   │   ├── roleplay_selector.dart
│   │   │   │   └── correction_badge.dart
│   │   │   └── chat_provider.dart
│   │   ├── reading/
│   │   │   ├── reading_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── article_viewer.dart
│   │   │   │   ├── article_search_bar.dart
│   │   │   │   └── reading_history_card.dart
│   │   │   └── reading_provider.dart
│   │   ├── profile/
│   │   │   ├── profile_page.dart
│   │   │   ├── stats_page.dart
│   │   │   ├── achievements_page.dart
│   │   │   ├── mistake_journal_page.dart
│   │   │   ├── weekly_report_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── achievement_card.dart
│   │   │   │   ├── stat_chart.dart
│   │   │   │   └── mistake_category.dart
│   │   │   └── profile_provider.dart
│   │   ├── settings/
│   │   │   ├── settings_page.dart
│   │   │   ├── ai_provider_settings.dart
│   │   │   ├── theme_settings.dart
│   │   │   ├── backup_settings.dart
│   │   │   ├── widgets/
│   │   │   │   ├── provider_tile.dart
│   │   │   │   └── api_key_input.dart
│   │   │   └── settings_provider.dart
│   │   ├── gamification/
│   │   │   ├── skill_tree_page.dart
│   │   │   ├── boss_battle_page.dart
│   │   │   ├── season_pass_page.dart
│   │   │   ├── leaderboard_page.dart
│   │   │   └── widgets/
│   │   │       ├── skill_node.dart
│   │   │       ├── boss_hp_bar.dart
│   │   │       └── season_tier.dart
│   │   └── writing/
│   │       ├── writing_page.dart
│   │       ├── correction_result_page.dart
│   │       └── writing_provider.dart
│   │
│   └── widgets/
│       ├── common/
│       │   ├── app_scaffold.dart
│       │   ├── loading_overlay.dart
│       │   ├── error_view.dart
│       │   ├── shimmer_placeholder.dart
│       │   ├── animated_button.dart
│       │   ├── progress_bar.dart
│       │   ├── xp_badge.dart
│       │   ├── streak_flame.dart
│       │   └── gem_counter.dart
│       ├── vocab/
│       │   ├── vocab_image.dart
│       │   ├── related_vocab_bar.dart
│       │   └── vocab_audio_button.dart
│       └── gamification/
│           ├── achievement_popup.dart
│           ├── xp_animation.dart
│           ├── spin_wheel.dart
│           └── season_pass_tier.dart
│
├── assets/
│   ├── images/
│   │   ├── logo.svg
│   │   ├── logo_dark.svg
│   │   ├── onboarding_1.svg
│   │   ├── onboarding_2.svg
│   │   ├── onboarding_3.svg
│   │   ├── empty_state.svg
│   │   └── error_state.svg
│   ├── audio/                              # TTS generated files (cached)
│   ├── animations/
│   │   ├── loading.riv                     # Rive animation
│   │   ├── achievement.riv
│   │   └── streak.riv
│   └── fonts/                              # Custom fonts (optional)
│
├── test/
│   ├── unit/
│   │   ├── services/
│   │   │   ├── ai_provider_test.dart
│   │   │   ├── duckduckgo_service_test.dart
│   │   │   ├── sr_service_test.dart
│   │   │   ├── gamification_service_test.dart
│   │   │   └── course_cache_manager_test.dart
│   │   ├── database/
│   │   │   ├── vocab_dao_test.dart
│   │   │   └── progress_dao_test.dart
│   │   └── models/
│   │       ├── translation_result_test.dart
│   │       └── word_detail_test.dart
│   ├── widget/
│   │   ├── vocab_widgets_test.dart
│   │   ├── quiz_widgets_test.dart
│   │   └── gamification_widgets_test.dart
│   └── integration/
│       ├── translator_flow_test.dart
│       ├── lesson_flow_test.dart
│       └── course_creation_test.dart
│
├── .github/
│   ├── workflows/
│   │   └── build_apk.yml                   # Trigger: tag v*
│   ├── CODEOWNERS
│   └── dependabot.yml
│
├── android/
│   ├── app/
│   │   ├── build.gradle.kts
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       └── res/                        # Icons, splash screen
│   └── gradle/
│       └── wrapper/
│           └── gradle-wrapper.properties
│
├── ios/                                     # Minimal (target utama Android)
├── pubspec.yaml
├── analysis_options.yaml
├── PRD.md
├── AGENT.md
└── README.md
```

---

## 🧠 CODE CONVENTIONS

### Naming
- **Files**: `snake_case.dart` (e.g. `translation_service.dart`, `user_vocab_sr.dart`)
- **Classes**: `PascalCase` (e.g. `TranslationService`, `UserVocabSr`)
- **Functions/Variables**: `camelCase` (e.g. `getTranslation()`, `currentStreak`)
- **Database tables**: `snake_case` (e.g. `user_lesson_progress`)
- **Constants**: `UPPER_SNAKE_CASE` (e.g. `MAX_COURSES`)
- **Private**: prefix `_` (e.g. `_cacheManager`)

### Imports Order
1. Dart SDK (`dart:io`, `dart:convert`)
2. Flutter (`package:flutter/...`)
3. Third-party (`package:riverpod/...`, `package:drift/...`)
4. Project (`package:llanguage/...`)
5. Relative (`../widgets/...`)

### State Management
- **Riverpod** untuk semua state
- `Notifier` / `AsyncNotifier` untuk business logic
- `Provider` untuk dependency injection
- JANGAN pake `setState` di luar widget trivial
- JANGAN pake `InheritedWidget` langsung

### Error Handling
- Semua service return `Result<T>` pattern atau `AsyncValue<T>`
- Jangan throw exception mentah
- Handle error di UI layer dengan `errorView` widget

### Comments
- **TIDAK BOLEH** ada komentar explainatory di kode
- **BOLEH** ada `// TODO:` untuk pekerjaan yang ditunda
- **BOLEH** ada `// HACK:` untuk workaround yang perlu diperbaiki
- **WAJIB** ada komentar di bagian yang tidak intuitif

### Testing
- Unit test untuk semua service
- Widget test untuk komponen UI utama
- Integration test untuk flow kritis (translator, lesson, quiz)

---

## 🗄️ DATABASE SCHEMA (DRIFT)

### app_database.dart

```dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ===================== TABLES =====================

// --- Core Content ---
@DataClassName('Course')
class Courses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().unique()();          // 'en', 'ja', 'ko'
  TextColumn get name => text()();                    // 'English'
  TextColumn get nativeName => text().nullable()();   // 'Bahasa Inggris'
  TextColumn get flagEmoji => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get sourceLanguageCode => text().withDefault(const Constant('id'))();
  TextColumn get targetLanguageCode => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get totalXp => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('Level')
class Levels extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get courseId => integer().references(Courses, #id, onDelete: KeyAction.cascade)();
  IntColumn get number => integer()();
  TextColumn get name => text()();
  TextColumn get cefrLevel => text().nullable()();   // 'A1', 'A2', 'B1'
  IntColumn get minXpRequired => integer().withDefault(const Constant(0))();
  TextColumn get description => text().nullable()();
  IntColumn get orderIndex => integer()();
}

@DataClassName('Unit')
class Units extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get levelId => integer().references(Levels, #id, onDelete: KeyAction.cascade)();
  IntColumn get number => integer()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get orderIndex => integer()();
}

@DataClassName('Lesson')
class Lessons extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get unitId => integer().references(Units, #id, onDelete: KeyAction.cascade)();
  IntColumn get number => integer()();
  TextColumn get name => text()();
  TextColumn get type => text()();  // 'new_words','dialogue','grammar','quiz','story','listening','speaking','writing'
  IntColumn get orderIndex => integer()();
  IntColumn get xpReward => integer().withDefault(const Constant(10))();
  IntColumn get estimatedMinutes => integer().withDefault(const Constant(5))();
  BoolColumn get isReview => boolean().withDefault(const Constant(false))();
}

// --- Vocabulary (SUPER COMPLETE) ---
@DataClassName('Vocab')
class Vocab extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId => integer().references(Lessons, #id, onDelete: KeyAction.cascade).nullable()();
  TextColumn get word => text()();
  TextColumn get lemma => text().nullable()();
  TextColumn get originalWord => text().nullable()();
  TextColumn get partOfSpeech => text().nullable()();
  TextColumn get posTag => text().nullable()();
  TextColumn get ipa => text().nullable()();
  TextColumn get ipaAmerican => text().nullable()();
  TextColumn get ipaBritish => text().nullable()();
  TextColumn get audioGuide => text().nullable()();
  TextColumn get syllables => text().nullable()();
  IntColumn get syllableCount => integer().nullable()();

  // Inflection
  TextColumn get baseForm => text().nullable()();
  TextColumn get thirdPersonSingular => text().nullable()();
  TextColumn get pastTense => text().nullable()();
  TextColumn get pastParticiple => text().nullable()();
  TextColumn get presentParticiple => text().nullable()();
  TextColumn get gerund => text().nullable()();
  TextColumn get infinitive => text().nullable()();
  TextColumn get pluralForm => text().nullable()();
  TextColumn get singularForm => text().nullable()();
  TextColumn get comparative => text().nullable()();
  TextColumn get superlative => text().nullable()();
  TextColumn get gender => text().nullable()();

  // Etymology
  TextColumn get etymologyOrigin => text().nullable()();
  TextColumn get rootLanguage => text().nullable()();
  TextColumn get rootMeaning => text().nullable()();
  TextColumn get firstRecordedUse => text().nullable()();
  TextColumn get wordFormation => text().nullable()();

  // Frequency
  TextColumn get frequencyBand => text().nullable()();
  TextColumn get cefrLevel => text().nullable()();
  TextColumn get difficultyLevel => text().nullable()();

  // Connotation
  RealColumn get sentimentScore => real().nullable()();
  BoolColumn get isTaboo => boolean().withDefault(const Constant(false))();
  BoolColumn get isOffensive => boolean().withDefault(const Constant(false))();

  // Visual
  TextColumn get emoji => text().nullable()();
  TextColumn get colorHex => text().nullable()();
  TextColumn get imageLocalPath => text().nullable()();    // DDG cached image

  // JSON blobs
  TextColumn get synonymsJson => text().nullable()();
  TextColumn get antonymsJson => text().nullable()();
  TextColumn get hypernymsJson => text().nullable()();
  TextColumn get hyponymsJson => text().nullable()();
  TextColumn get meronymsJson => text().nullable()();
  TextColumn get holonymsJson => text().nullable()();
  TextColumn get meaningClustersJson => text().nullable()();
  TextColumn get collocationsJson => text().nullable()();
  TextColumn get examplesJson => text().nullable()();
  TextColumn get commonErrorsJson => text().nullable()();
  TextColumn get phrasalVerbsJson => text().nullable()();
  TextColumn get derivedFormsJson => text().nullable()();
  TextColumn get falseFriendsJson => text().nullable()();
  TextColumn get idiomaticUsagesJson => text().nullable()();
  TextColumn get registerJson => text().nullable()();
  TextColumn get dialectalJson => text().nullable()();
  TextColumn get crossLinguisticJson => text().nullable()();
  TextColumn get cognatesJson => text().nullable()();
  TextColumn get pedagogicalNotesJson => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// FTS5 for full-text search
@UseRowClass(VocabFts)
class VocabFts extends Table {
  TextColumn get word => text()();
  TextColumn get lemma => text()();
  TextColumn get originalWord => text()();
  TextColumn get ipa => text()();
  TextColumn get audioGuide => text()();

  @override
  Set<Column> get primaryKey => {word};

  @override
  bool get withoutRowId => true;

  @override
  String? get tableName => 'vocab_fts';

  @override
  String get createTable => 'CREATE VIRTUAL TABLE vocab_fts USING fts5('
      'word, lemma, original_word, ipa, audio_guide, '
      "content='vocab', content_rowid='id')";
}

// --- Grammar ---
@DataClassName('Grammar')
class Grammar extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId => integer().references(Lessons, #id, onDelete: KeyAction.cascade).nullable()();
  TextColumn get title => text()();
  TextColumn get rule => text()();
  TextColumn get explanation => text()();
  TextColumn get pattern => text().nullable()();
  TextColumn get correctExamplesJson => text().nullable()();
  TextColumn get incorrectExamplesJson => text().nullable()();
  TextColumn get visualHint => text().nullable()();
  TextColumn get difficultyLevel => text().nullable()();
  TextColumn get relatedGrammarIdsJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// --- Dialogues ---
@DataClassName('Dialogue')
class Dialogues extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId => integer().references(Lessons, #id, onDelete: KeyAction.cascade).nullable()();
  TextColumn get title => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('DialogueLine')
class DialogueLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dialogueId => integer().references(Dialogues, #id, onDelete: KeyAction.cascade)();
  IntColumn get lineNumber => integer()();
  TextColumn get speaker => text()();
  TextColumn get textSource => text()();
  TextColumn get textTarget => text()();
  TextColumn get translation => text().nullable()();
  TextColumn get audioPath => text().nullable()();
  TextColumn get vocabHighlightIdsJson => text().nullable()();
}

// --- Quiz ---
@DataClassName('QuizQuestion')
class QuizQuestions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId => integer().references(Lessons, #id, onDelete: KeyAction.cascade).nullable()();
  TextColumn get type => text()();  // 'mcq','typing','matching','ordering','listening','writing','speaking'
  TextColumn get prompt => text()();
  TextColumn get promptAudioPath => text().nullable()();
  TextColumn get correctAnswer => text()();
  TextColumn get optionsJson => text().nullable()();
  TextColumn get hintsJson => text().nullable()();
  TextColumn get explanation => text().nullable()();
  TextColumn get mediaPath => text().nullable()();
  TextColumn get difficulty => text().withDefault(const Constant('medium'))();
  IntColumn get xpReward => integer().withDefault(const Constant(15))();
  IntColumn get timeLimitSeconds => integer().nullable()();
  TextColumn get vocabIdsJson => text().nullable()();
  IntColumn get orderIndex => integer()();
}

// --- Stories ---
@DataClassName('Story')
class Stories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get unitId => integer().references(Units, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('StoryPanel')
class StoryPanels extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get storyId => integer().references(Stories, #id, onDelete: KeyAction.cascade)();
  IntColumn get panelNumber => integer()();
  TextColumn get imagePath => text().nullable()();
  TextColumn get textSource => text()();
  TextColumn get textTarget => text()();
  TextColumn get translation => text().nullable()();
  TextColumn get audioPath => text().nullable()();
  TextColumn get vocabIdsJson => text().nullable()();
}

@DataClassName('StoryQuestion')
class StoryQuestions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get storyId => integer().references(Stories, #id, onDelete: KeyAction.cascade)();
  TextColumn get question => text()();
  TextColumn get type => text().withDefault(const Constant('mcq'))();
  TextColumn get optionsJson => text().nullable()();
  TextColumn get correctAnswer => text()();
  TextColumn get explanation => text().nullable()();
}

// --- User Progress ---
@DataClassName('UserLessonProgress')
class UserLessonProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId => integer().references(Lessons, #id, onDelete: KeyAction.cascade)();
  TextColumn get status => text().withDefault(const Constant('locked'))();  // 'locked','unlocked','in_progress','completed'
  RealColumn get bestScore => real().nullable()();
  IntColumn get xpEarned => integer().withDefault(const Constant(0))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  IntColumn get timeSpentSeconds => integer().withDefault(const Constant(0))();
  DateTimeColumn get firstUnlockedAt => dateTime().nullable()();
  DateTimeColumn get lastPlayedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
}

@DataClassName('UserQuizAttempt')
class UserQuizAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get quizQuestionId => integer().references(QuizQuestions, #id, onDelete: KeyAction.cascade)();
  TextColumn get userAnswer => text().nullable()();
  BoolColumn get isCorrect => integer()();
  IntColumn get timeTakenSeconds => integer().nullable()();
  BoolColumn get hintUsed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get attemptedAt => dateTime().withDefault(currentDateAndTime)();
}

// --- Spaced Repetition (SM-2) ---
@DataClassName('UserVocabSr')
class UserVocabSr extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vocabId => integer().references(Vocab, #id, onDelete: KeyAction.cascade)();
  IntColumn get stage => integer().withDefault(const Constant(0))();
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();
  IntColumn get intervalDays => integer().withDefault(const Constant(0))();
  IntColumn get correctCount => integer().withDefault(const Constant(0))();
  IntColumn get incorrectCount => integer().withDefault(const Constant(0))();
  IntColumn get consecutiveCorrect => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();
  DateTimeColumn get nextReviewAt => dateTime().nullable()();
  BoolColumn get isMature => boolean().withDefault(const Constant(false))();
}

// --- Mistakes Journal ---
@DataClassName('UserMistake')
class UserMistakes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vocabId => integer().references(Vocab, #id).nullable()();
  IntColumn get grammarId => integer().references(Grammar, #id).nullable()();
  TextColumn get mistakeType => text()();  // 'vocab','grammar','spelling','pronunciation','article','tense','preposition'
  TextColumn get userInput => text()();
  TextColumn get correctForm => text()();
  TextColumn get rule => text().nullable()();
  TextColumn get explanation => text().nullable()();
  TextColumn get context => text().nullable()();
  IntColumn get count => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastOccurredAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isResolved => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// --- Streak ---
@DataClassName('UserStreak')
class UserStreak extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();
  TextColumn get lastActiveDate => text().nullable()();  // 'YYYY-MM-DD'
  IntColumn get freezeCount => integer().withDefault(const Constant(0))();
  IntColumn get totalDaysLearned => integer().withDefault(const Constant(0))();
}

@DataClassName('UserStreakHistoryDay')
class UserStreakHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text().unique()();  // 'YYYY-MM-DD'
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get xpEarned => integer().withDefault(const Constant(0))();
  IntColumn get lessonsCompleted => integer().withDefault(const Constant(0))();
}

// --- XP & Gems ---
@DataClassName('UserXpLog')
class UserXpLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get amount => integer()();
  TextColumn get source => text()();  // 'lesson','quiz_perfect','streak','achievement','daily_reward'
  IntColumn get referenceId => integer().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('UserGems')
class UserGems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get balance => integer().withDefault(const Constant(0))();
  IntColumn get lifetimeEarned => integer().withDefault(const Constant(0))();
  IntColumn get lifetimeSpent => integer().withDefault(const Constant(0))();
}

@DataClassName('UserGemsLog')
class UserGemsLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get amount => integer()();
  TextColumn get type => text()();  // 'earned','spent'
  TextColumn get source => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// --- Achievements ---
@DataClassName('Achievement')
class Achievements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().unique()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get iconPath => text().nullable()();
  IntColumn get xpReward => integer().withDefault(const Constant(50))();
  IntColumn get gemReward => integer().withDefault(const Constant(10))();
  TextColumn get criteriaJson => text().nullable()();
  TextColumn get category => text().withDefault(const Constant('general'))();
}

@DataClassName('UserAchievement')
class UserAchievements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get achievementId => integer().references(Achievements, #id)();
  DateTimeColumn get unlockedAt => dateTime().withDefault(currentDateAndTime)();
}

// --- Chat ---
@DataClassName('ChatSession')
class ChatSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().nullable()();
  TextColumn get mode => text().withDefault(const Constant('free'))();
  TextColumn get roleplayContext => text().nullable()();
  TextColumn get targetLanguageCode => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('ChatMessage')
class ChatMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(ChatSessions, #id, onDelete: KeyAction.cascade)();
  TextColumn get role => text()();  // 'user','assistant','system'
  TextColumn get content => text()();
  TextColumn get correctionJson => text().nullable()();
  TextColumn get grammarNotes => text().nullable()();
  TextColumn get vocabHighlightIdsJson => text().nullable()();
  TextColumn get audioPath => text().nullable()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

// --- Writing Correction ---
@DataClassName('WritingHistory')
class WritingHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userInput => text()();
  TextColumn get correctedText => text()();
  TextColumn get correctionsJson => text().nullable()();
  TextColumn get overallFeedback => text().nullable()();
  IntColumn get score => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// --- Reading History ---
@DataClassName('ReadingHistory')
class ReadingHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get topic => text()();
  TextColumn get sourceUrl => text().nullable()();
  TextColumn get title => text().nullable()();
  TextColumn get contentJson => text()();
  TextColumn get tappedVocabIdsJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// --- Vocab Suggestions (Related Vocab) ---
@DataClassName('VocabSuggestion')
class VocabSuggestions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vocabId => integer().references(Vocab, #id)();
  TextColumn get suggestedWord => text()();
  TextColumn get source => text().withDefault(const Constant('ddg'))();
  BoolColumn get isDismissed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// --- Course Access Tracking (LRU) ---
@DataClassName('CourseAccessTracking')
class CourseAccessTracking extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get courseId => integer().references(Courses, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get lastAccessedAt => dateTime()();
  IntColumn get accessCount => integer().withDefault(const Constant(1))();
  IntColumn get totalXpEarned => integer().withDefault(const Constant(0))();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
}

// --- AI Cache ---
@DataClassName('AiCache')
class AiCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get cacheKey => text().unique()();
  TextColumn get model => text()();
  TextColumn get responseJson => text()();
  IntColumn get tokensUsed => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  IntColumn get accessCount => integer().withDefault(const Constant(1))();
}

// ===================== DATABASE =====================
@DriftDatabase(
  tables: [
    Courses, Levels, Units, Lessons,
    Vocab, VocabFts, Grammar,
    Dialogues, DialogueLines,
    QuizQuestions,
    Stories, StoryPanels, StoryQuestions,
    UserLessonProgress, UserQuizAttempts,
    UserVocabSr, UserMistakes,
    UserStreak, UserStreakHistory,
    UserXpLog, UserGems, UserGemsLog,
    Achievements, UserAchievements,
    ChatSessions, ChatMessages,
    WritingHistory,
    ReadingHistory,
    VocabSuggestions,
    CourseAccessTracking,
    AiCache,
  ],
  daos: [
    CourseDao, VocabDao, ProgressDao,
    GamificationDao, SrDao, ChatDao,
    MistakeDao, CacheDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => ...;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'llanguage.db'));
    return NativeDatabase(file);
  });
}
```

---

## 🔧 AI PROVIDER INTEGRATION

### Abstract Provider

```dart
abstract class AiProvider {
  String get name;
  String get baseUrl;
  String get defaultModel;

  Future<AiResponse> complete({
    required List<ChatMessage> messages,
    String? model,
    Map<String, dynamic>? extraParams,
  });
}

class ChatMessage {
  final String role;   // 'system', 'user', 'assistant'
  final String content;
}

class AiResponse {
  final String content;
  final int promptTokens;
  final int completionTokens;
  final String model;
}
```

### OpenAI-compatible Adapter

```dart
class OpenaiAdapter implements AiProvider {
  final String baseUrl;
  final String apiKey;
  final String model;

  Future<AiResponse> complete({...}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model,
        'messages': messages,
        'response_format': {'type': 'json_object'},
        'temperature': 0.3,  // low temp for deterministic output
      }),
    );

    if (response.statusCode != 200) {
      throw AiException(response.statusCode, response.body);
    }

    final data = jsonDecode(response.body);
    return AiResponse(
      content: data['choices'][0]['message']['content'],
      promptTokens: data['usage']['prompt_tokens'],
      completionTokens: data['usage']['completion_tokens'],
      model: data['model'],
    );
  }
}
```

### Preset Providers

```dart
class OpenRouterProvider extends OpenaiAdapter {
  OpenRouterProvider(String apiKey, {String? model})
    : super(
        baseUrl: 'https://openrouter.ai/api/v1',
        apiKey: apiKey,
        model: model ?? 'anthropic/claude-sonnet-4-20250514',
      );
}

class GroqProvider extends OpenaiAdapter {
  GroqProvider(String apiKey, {String? model})
    : super(
        baseUrl: 'https://api.groq.com/openai/v1',
        apiKey: apiKey,
        model: model ?? 'llama-3.3-70b-versatile',
      );
}

class XaiProvider extends OpenaiAdapter {
  XaiProvider(String apiKey, {String? model})
    : super(
        baseUrl: 'https://api.x.ai/v1',
        apiKey: apiKey,
        model: model ?? 'grok-2-latest',
      );
}

class DeepSeekProvider extends OpenaiAdapter {
  DeepSeekProvider(String apiKey, {String? model})
    : super(
        baseUrl: 'https://api.deepseek.com',
        apiKey: apiKey,
        model: model ?? 'deepseek-chat',
      );
}

class OllamaProvider extends OpenaiAdapter {
  OllamaProvider({String? model})
    : super(
        baseUrl: 'http://localhost:11434/v1',
        apiKey: '',  // Ollama doesn't need key
        model: model ?? 'llama3',
      );
}

class CustomProvider extends OpenaiAdapter {
  CustomProvider({
    required String baseUrl,
    required String apiKey,
    required String model,
  }) : super(baseUrl: baseUrl, apiKey: apiKey, model: model);
}
```

### Error Handling

```dart
class AiException implements Exception {
  final int statusCode;
  final String body;

  // 401 → API key invalid
  // 429 → Rate limited (retry after delay)
  // 500 → Server error (retry)
  // Timeout → Connection error
}

// Retry logic: 3 attempts with exponential backoff
// 1st: 1s delay
// 2nd: 3s delay
// 3rd: 5s delay, then fail
```

---

## 🦆 DUCKDUCKGO SERVICE

```dart
class DuckDuckGoService {
  static const String _baseUrl = 'https://api.duckduckgo.com';

  /// Instant Answer API — gratis, no API key
  Future<DdgInstantResult?> instantAnswer(String query) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'q': query,
      'format': 'json',
      'no_html': '1',
      'skip_disambig': '1',
    });

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body);
      return DdgInstantResult.fromJson(json);
    } catch (e) {
      return null;  // Silent fail — fallback ke AI
    }
  }

  /// Quick definition — ambil dari Abstract + Definition
  Future<String?> getDefinition(String word) async {
    final result = await instantAnswer('define $word');
    return result?.definition ?? result?.abstract;
  }

  /// Gambar — ambil dari Image field
  Future<String?> getImageUrl(String word) async {
    final result = await instantAnswer(word);
    return result?.image;
  }

  /// Related topics — ambil dari RelatedTopics array
  Future<List<DdgRelatedTopic>> getRelatedTopics(String word) async {
    final result = await instantAnswer(word);
    return result?.relatedTopics ?? [];
  }

  /// Article search — untuk Reading Mode (parsing HTML search)
  Future<List<DdgArticle>> searchArticles(String topic) async {
    final uri = Uri.parse('https://html.duckduckgo.com/html').replace(
      queryParameters: {'q': 'simple english about $topic for beginner'},
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode != 200) return [];

      return _parseArticles(response.body);
    } catch (e) {
      return [];
    }
  }

  List<DdgArticle> _parseArticles(String html) {
    // Parse HTML untuk ambil title, snippet, URL
    // Package: html (dart)
  }
}
```

---

## 📦 PUBSPEC.YAML DEPENDENCIES

```yaml
name: llanguage
description: LLanguage — Aplikasi Belajar Bahasa Super Lengkap
version: 1.0.0

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.24.0'

dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Navigation
  go_router: ^14.2.0

  # Database
  drift: ^2.20.0
  sqlite3_flutter_libs: ^0.5.0
  path_provider: ^2.1.3
  path: ^1.9.0

  # Secure Storage (API keys)
  flutter_secure_storage: ^9.2.2

  # HTTP
  http: ^1.2.1

  # TTS
  flutter_tts: ^4.0.2

  # Notifications
  flutter_local_notifications: ^17.2.1

  # Voice (speech to text)
  speech_to_text: ^6.6.2

  # File handling (export/backup)
  share_plus: ^9.0.0
  file_saver: ^0.2.14

  # PDF for export
  pdf: ^3.11.0

  # Charts for weekly report
  fl_chart: ^0.68.0

  # Animations
  lottie: ^3.1.2          # or rive: ^0.13.4

  # Widget (home screen)
  home_widget: ^0.7.0

  # HTML parsing (for DDG articles)
  html: ^0.15.4

  # EPUB parsing
  epubx: ^2.0.3

  # JSON serialization
  json_annotation: ^4.9.0
  freezed_annotation: ^2.4.4

  # Utils
  uuid: ^4.4.1
  intl: ^0.19.0
  equatable: ^2.0.5
  sembast: ^3.7.4          # backup/export
  archive: ^3.6.1          # zip backup
  crypto: ^3.0.3           # cache key hashing

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

  # Code generation
  drift_dev: ^2.20.0
  build_runner: ^2.4.9
  json_serializable: ^6.8.0
  freezed: ^2.5.2
  riverpod_generator: ^2.4.3
  mocktail: ^1.0.3
```

---

## 📦 FITUR IMPLEMENTATION ORDER (CRITICAL)

### Phase 1: Foundation (WAJIB URUT)
```
[1.1] Setup Flutter project + pubspec.yaml + folder structure
[1.2] Setup core services (theme, router, constants, utils)
[1.3] Setup Drift database (schema lengkap)
[1.4] Setup AI Provider adapter + preset providers
[1.5] Setup DuckDuckGo service
[1.6] Setup Secure Storage (API key management)
[1.7] Setup GitHub Actions workflow
```

### Phase 2: Core Features (BISA PARALEL)
```
[2A] Deep Translation + Quick Definition (translator page)
     └── depends on: 1.4, 1.5, 1.6
     └── subagent: translator service, tappable text, word detail sheet

[2B] Course system + Lesson player + Flashcard
     └── depends on: 1.3
     └── subagent: course CRUD, lesson player, flashcard widget

[2C] Quiz engine (MCQ, typing, matching, ordering, listening)
     └── depends on: 1.3
     └── subagent: quiz page, 5 quiz types

[2D] Gamification (XP, streak, achievement, gems, spin wheel)
     └── depends on: 1.3
     └── subagent: gamification service, streak tracking, achievement checks

[2E] Spaced Repetition (SM-2)
     └── depends on: 1.3, 2B
     └── subagent: SR service, review page, SR card widget
```

### Phase 3: DuckDuckGo Features (BISA PARALEL, depends on 1.5)
```
[3A] Reading Mode
     └── depends on: 1.5, 2A (tappable text)

[3B] Image Flashcard
     └── depends on: 1.5, 2B

[3C] Related Vocab Suggestions
     └── depends on: 1.5, 2A
```

### Phase 4: Advanced AI (BISA PARALEL)
```
[4A] AI Tutor Chat
     └── depends on: 1.4, 2D (XP)

[4B] Writing Corrector
     └── depends on: 1.4

[4C] Skill Tree + Boss Battle + Season Pass
     └── depends on: 2D (gamification system)

[4D] Mistake Journal + Weekly Report
     └── depends on: 2C, 2D

[4E] Backup/Restore + Export
     └── depends on: 1.3

[4F] Language-specific features (Tone, Kanji, Hangul, etc)
     └── depends on: 2B, 2C
```

### Phase 5: Polish (BISA PARALEL)
```
[5A] Widget + Notifications + Voice Commands
[5B] Dark mode + Custom theme + Animations
[5C] GitHub Actions final polish
[5D] Testing (unit + widget + integration)
[5E] Bug fixes & optimization
```

---

## 🤖 SUBAGENT STRATEGY

### Cara Memanggil Subagent

Gunakan `task` tool dengan `subagent_type: "general"` untuk task yang mandiri.

**PENTING:** Setiap subagent WAJIB membaca AGENT.md ini dulu sebelum mulai kerja.

Template panggilan subagent:

```
## TASK: {NAMA FITUR}
## BACA AGENT.md DAHULU — file ini berisi semua konvensi, struktur, dan aturan proyek

### Yang harus dikerjakan:
- {list task detail}

### Dependencies:
- {file/fitur apa yang harus udah ada}

### Output yang diharapkan:
- {file apa yang dibuat/diedit}

### Catatan:
- JANGAN pake cloud DB, Firebase, Supabase, dll
- Gunakan DuckDuckGo MCP yang tersedia untuk searching referensi
- Update AGENT.md bagian "Last Updated" setelah selesai
```

### Resource Allocation

```
Phase 1 → 1 agent sequential (gak bisa paralel karena dependen)
Phase 2 → Max 5 agent paralel (A, B, C, D, E)
Phase 3 → Max 3 agent paralel (A, B, C)
Phase 4 → Max 6 agent paralel (A, B, C, D, E, F)
Phase 5 → Max 5 agent paralel (A, B, C, D, E)
```

### Agent Communication

- **Output** dari setiap subagent: daftar file yang dibuat/diedit, perubahan schema (jika ada)
- **Dependency check**: sebelum mulai, cek apakah dependency file sudah ada
- **Conflict avoidance**: jangan edit file yang sedang diedit agent lain (cek git status dulu)

---

## ✅ CHECKLIST SEBELUM COMMIT

Setiap agent WAJIB checklist ini sebelum commit:

```
[  ] flutter analyze — 0 error, 0 warning
[  ] dart run build_runner build — sukses (jika ada perubahan schema/model)
[  ] flutter test — semua passing (jika ada test terkait)
[  ] Tidak ada import yang unused
[  ] Tidak ada kode yang dikomentari (kecuali TODO/HACK)
[  ] File baru sudah sesuai struktur folder
[  ] Tidak ada Firebase/Supabase/MongoDB dependency
[  ] AGENT.md di-update jika ada perubahan struktur/schema
```

---

## 🧪 TESTING STRATEGY

### Unit Tests
- `sr_service_test.dart` — SM-2 algorithm correctness
- `gamification_service_test.dart` — XP/streak/achievement logic
- `course_cache_manager_test.dart` — LRU eviction logic
- `translation_service_test.dart` — hybrid layer flow

### Widget Tests
- `tappable_text_test.dart` — word tap detection
- `quiz_widgets_test.dart` — MCQ/typing/matching interaction
- `word_detail_sheet_test.dart` — layer transitions

### Integration Tests
- `translator_flow_test.dart` — input → DDG layer → AI layer → display
- `lesson_flow_test.dart` — course select → lesson → quiz → results
- `course_creation_test.dart` — AI generate → save → display

---

## 🔄 TDD WORKFLOW PER PHASE

Setiap phase/feature WAJIB dikerjakan dengan urutan TDD:

```
┌─────────────────────────────────────────────┐
│          TDD CYCLE PER FITUR                  │
│                                               │
│  STEP 1: WRITE TEST FIRST                     │
│  ├── Test dulu sebelum implementasi          │
│  ├── Definisikan expected behavior           │
│  ├── Test akan FAIL (red)                    │
│  └── commit: "test(feature): add test for X" │
│                                               │
│  STEP 2: MINIMAL IMPLEMENTATION              │
│  ├── Tulis kode paling minimal agar test pass│
│  ├── Jangan optimasi/premature               │
│  └── commit: "feat(feature): implement X"    │
│                                               │
│  STEP 3: REFACTOR                            │
│  ├── Clean up kode                           │
│  ├── Pastikan semua test masih PASS (green)  │
│  └── commit: "refactor(feature): clean up X" │
│                                               │
│  STEP 4: LANJUT FITUR BERIKUTNYA             │
└─────────────────────────────────────────────┘
```

### Aturan TDD Wajib

| Aturan | Keterangan |
|---|---|
| **Test dulu, kode setelah** | Gak boleh nulis implementasi tanpa test dulu |
| **1 commit = 1 siklus** | test → impl → refactor masing-masing 1 commit |
| **Semua test harus passing** | Sebelum lanjut ke fitur berikutnya |
| **Jangan skip test** | Test menentukan apakah fitur selesai atau belum |
| **Regression test** | Kalau ada bug, tulis test dulu baru fix |

### Contoh Flow TDD untuk Phase 2A (Deep Translation)

```
COMMIT 1 — "test(translator): add AI adapter test"
  ├── test/services/ai/openai_adapter_test.dart
  ├── test dulu tanpa implementasi
  └── flutter test → FAIL (expected)

COMMIT 2 — "feat(translator): implement AI adapter"
  ├── lib/services/ai/openai_adapter.dart
  ├── implementasi minimal
  └── flutter test → PASS

COMMIT 3 — "test(translator): add DuckDuckGo service test"
  ├── test/services/duckduckgo/duckduckgo_service_test.dart
  └── flutter test → FAIL

...

COMMIT N — "feat(translator): complete hybrid translation flow"
  ├── integration test pass
  └── semua test → PASS
```

### Test Coverage Minimum Per Phase

| Phase | Coverage Target | Fokus |
|---|---|---|
| **Phase 1: Foundation** | 90%+ unit test | Database, services core |
| **Phase 2: Core** | 85%+ | Service logic, edge cases |
| **Phase 3: DDG** | 75%+ | Parsing, fallback, cache |
| **Phase 4: Advanced AI** | 80%+ | Integration flow |
| **Phase 5: Polish** | 70%+ | Widget test, UI interaction |

---

## 🔄 UPDATE PROTOCOL

### Kapan Update AGENT.md
- Ada perubahan struktur folder
- Ada perubahan database schema
- Ada perubahan dependency (pubspec.yaml)
- Ada perubahan arsitektur
- Fitur baru selesai diimplementasi

### Cara Update
```
1. Edit file AGENT.md
2. Update "Last Updated" date
3. Tambahkan changelog di bagian akhir
```

---

## 📝 CHANGELOG

| Date | Agent | Changes |
|---|---|---|
| 2026-07-08 | System | Initial AGENT.md creation — full project manual |
