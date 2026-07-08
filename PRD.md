# PRD: LLanguage — Aplikasi Belajar Bahasa Interaktif Super Lengkap

**Versi:** 1.0.0
**Status:** Draft
**Penulis:** AI Agent

---

## 1. Visi & Tujuan

Aplikasi belajar bahasa Android offline-first yang memberikan **pengalaman belajar super lengkap** — beda dari Duolingo/Memrise karena **setiap kata bisa di-explore sedetail mungkin** (sinonim, antonim, infleksi, etimologi, dll) dengan bantuan AI + DuckDuckGo API gratis.

### Prinsip Utama
- **100% lokal database** — NO Firebase, Supabase, MongoDB, atau cloud DB apapun
- **Offline-first** — setelah konten di-generate, semua fitur dasar jalan tanpa internet
- **AI Provider BYOK** (Bring Your Own Key) — user pakai API key sendiri (OpenRouter, Groq, xAI, dll)
- **DuckDuckGo API gratis** — untuk quick definition, gambar, related topics tanpa biaya
- **Hybrid layer** — DDG (instan, gratis) → AI (super lengkap, belakangan)
- **Dikembangkan dari HP** — build via GitHub Actions, zero SDK lokal

---

## 2. Tech Stack

| Layer | Teknologi | Alasan |
|---|---|---|
| **Framework** | Flutter 3.24.x | Cross-platform, UI kaya animasi, satu codebase |
| **Bahasa** | Dart 3.x | Type-safe, performa native |
| **Database** | Drift (SQLite) | Relational, type-safe, FTS5, migration support |
| **State Management** | Riverpod | Dependency injection, testable, codegen |
| **Navigation** | GoRouter | Declarative, deep linking ready |
| **Secure Storage** | flutter_secure_storage | API key encrypted |
| **AI Adapter** | OpenAI-compatible HTTP | Satu adapter untuk semua provider |
| **API Gratis** | DuckDuckGo Instant Answer | Definitions, images, related topics |
| **TTS** | flutter_tts | Text-to-speech offline (tergantung engine HP) |
| **CI/CD** | GitHub Actions | Build APK otomatis via tag push |

---

## 3. Target Pengguna

- **Umur:** 13+ tahun
- **Level:** Pemula (A1) hingga Mahir (C1)
- **Source Language:** Bahasa Indonesia (utama), bisa diperluas
- **Target Language:** English (utama), Japanese, Korean, Mandarin, French, Spanish, German, Arabic, dan lainnya via AI generate
- **Perangkat:** Android 8.0+ (API 26+)

---

## 4. Fitur Lengkap (51 Fitur)

### 4.1 AI-Powered Features (7)
| # | Fitur | Deskripsi | Layer |
|---|---|---|---|
| 1 | **Deep Translation** | Translate interaktif per kata dengan detail super lengkap | AI + DDG |
| 2 | **AI Tutor Chat** | Chat real-time roleplay (restoran, bandara, wawancara) | AI |
| 3 | **Writing Corrector** | User nulis → AI koreksi grammar + explanation | AI |
| 4 | **Pronunciation Coach** | Rekam suara → analisa fonetik | AI |
| 5 | **AI Generate Story** | Generate cerita dari vocab yang sudah dipelajari | AI |
| 6 | **Daily Conversation** | AI kirim pesan trigger harian → user bales dikoreksi | AI |
| 7 | **Context-Aware Hints** | Hint personalisasi berdasarkan mistake history user | AI |

### 4.2 DuckDuckGo-Powered Features (4)
| # | Fitur | Deskripsi | Layer |
|---|---|---|---|
| 8 | **Quick Definition** | Definisi instan dari DDG + AI super lengkap background | DDG → AI |
| 9 | **Image Flashcard** | Gambar vocab dari DDG, di-cache lokal | DDG |
| 10 | **Related Vocab** | Saran vocab terkait dari DDG related topics | DDG |
| 11 | **Reading Mode** | Artikel dari DDG search, tiap kata tappable | DDG → AI |

### 4.3 Gamification (7)
| # | Fitur | Deskripsi |
|---|---|---|
| 12 | **XP & Level System** | XP dari setiap aktivitas, naik level buka konten |
| 13 | **Streak** | Belajar tiap hari, streak freeze item |
| 14 | **Gems / Mata Uang** | Dapat dari lesson/streak/achievement, dipakai untuk hint/freeze/skin |
| 15 | **Achievement Badges** | 100+ badge, unlock otomatis berdasarkan milestone |
| 16 | **Skill Tree** | Graph skill: Present Tense → Past Tense → Perfect Tense |
| 17 | **Boss Battle** | Challenge mingguan, soal susah, HP bos, loot |
| 18 | **Season Pass** | Monthly season, misi harian/mingguan, reward tier |

### 4.4 Content & Learning Tools (8)
| # | Fitur | Deskripsi |
|---|---|---|
| 19 | **Flashcard Mode** | Swipe card (kiri=belum, kanan=ingat, bawah=ulang) |
| 20 | **Anki Export/Import** | Parse .apkg, import ke sistem SR |
| 21 | **Lyrics Translation** | Input lirik lagu → AI translate per baris |
| 22 | **Book Reader (EPUB/PDF)** | Upload file → inline tap-translate |
| 23 | **Word of the Day** | Notifikasi push tiap pagi, random vocab |
| 24 | **Grammar Reference** | Full grammar guide, searchable pake FTS5 |
| 25 | **Daily Reward Spin Wheel** | Random reward tiap hari (gems, freeze, XP boost) |
| 26 | **Custom Course Creator** | User buat course sendiri (vocab, soal, grammar) |

### 4.5 Social (Adaptasi Lokal) (3)
| # | Fitur | Deskripsi |
|---|---|---|
| 27 | **Shareable Cards** | Generate image card vocab → share via OS |
| 28 | **Local Leaderboard** | Ranking XP lokal, input temen manual |
| 29 | **Trading Cards** | Collectible vocab cards dengan rarity |

### 4.6 Device & Platform (4)
| # | Fitur | Deskripsi |
|---|---|---|
| 30 | **Android Widget** | Homescreen: streak, word of day, quick review |
| 31 | **Voice Commands** | Speech-to-text lokal: "Quiz me!", "Review now!" |
| 32 | **Dark Mode** | ThemeMode.dark/light/system |
| 33 | **Custom Theme** | Pilih warna aksen, font, background |

### 4.7 Learning Science (6)
| # | Fitur | Deskripsi |
|---|---|---|
| 34 | **Focus Mode (Pomodoro)** | Timer 25 menit + flashcard session |
| 35 | **Mistake Journal** | Catat semua error, tampilkan pola |
| 36 | **Weekly Report** | Aggregasi XP, waktu, accuracy, progress |
| 37 | **Adaptive Difficulty** | Soal naik/turun berdasarkan performa |
| 38 | **Learning Style Quiz** | Visual/Auditori/Kinestetik → UI disesuaikan |
| 39 | **Spaced Repetition (SM-2)** | Review otomatis jadwal optimal |

### 4.8 Advanced Tools (6)
| # | Fitur | Deskripsi |
|---|---|---|
| 40 | **Regex Search Vocab** | Cari vocab pake regex via FTS5 |
| 41 | **Export Progress** | Export CSV / PDF ke Download |
| 42 | **Backup & Restore** | Export full DB + file ke .llanguage_backup |
| 43 | **Plugin System** | Skrip/config Dart di-load runtime |
| 44 | **AI Provider Settings** | Ganti provider, model, API key kapan aja |
| 45 | **Course Cache Manager** | Max 2 course aktif, evict dengan backup |

### 4.9 Language-Specific Features (6)
| # | Fitur | Bahasa Target |
|---|---|---|
| 46 | **Tone Trainer** | Mandarin, Thai |
| 47 | **Kanji Stroke Order** | Jepang |
| 48 | **Hangul Composition** | Korea |
| 49 | **Gender Practice** | Perancis, Spanyol, Jerman |
| 50 | **Case System** | Jerman, Rusia |
| 51 | **Pitch Accent** | Jepang |

---

## 5. Arsitektur Aplikasi

### 5.1 Layer Architecture

```
┌─────────────────────────────────────────────┐
│                UI LAYER                       │
│  Pages → Widgets → Riverpod Providers        │
├─────────────────────────────────────────────┤
│              SERVICE LAYER                    │
│  Translation  │  AI Chat  │  Quiz            │
│  Lesson       │  Review   │  Gamification    │
│  Backup       │  Export   │  MistakeJournal  │
├─────────────────────────────────────────────┤
│              DATA LAYER                      │
│  DriftDatabase (SQLite)  │  SecureStorage    │
│  File IO                 │  In-memory Cache  │
├─────────────────────────────────────────────┤
│              EXTERNAL LAYER                   │
│  AI Provider (OpenAI-compatible HTTP)        │
│  DuckDuckGo Instant Answer API (gratis)      │
│  TTS Engine (local)                          │
└─────────────────────────────────────────────┘
```

### 5.2 Hybrid Data Flow (DDG + AI)

```
User tap word "apple"
       │
       ▼
┌──────────────────────┐
│ CHECK CACHE          │──Ada?──→ Tampilkan dari cache (instan)
│ (ai_cache table)     │
└──────────┬───────────┘
           │ Miss
           ▼
┌──────────────────────┐
│ LAYER 1: DuckDuckGo  │  ← 50-200ms, GRATIS
│ • Definition singkat │
│ • Gambar (URL)       │
│ • Related topics     │
└──────────┬───────────┘
           │ Tampilkan Quick Card (muncul <300ms)
           ▼
┌──────────────────────┐
│ LAYER 2: AI Provider │  ← 1-5 detik, pake token user
│ • Super complete     │
│ • Synonyms+nuances   │
│ • Inflection table   │
│ • Etymology          │
│ • Common mistakes    │
│ • Examples           │
└──────────┬───────────┘
           │ Update UI → Full Card
           ▼
    Simpan ke cache
```

### 5.3 Course Cache Strategy

```
Rules:
- MAX 2 active courses
- LRU eviction: yang paling lama diakses dihapus
- PIN support: pinned course tidak bisa di-evict
- Auto backup sebelum evict: export ke .llanguage_backup
- User dikasih warning + pilihan sebelum evict

Flow create course baru:
1. Cek jumlah course aktif
2. Jika < 2 → langsung create
3. Jika = 2:
   a. Cek ada yang unpinned? → evict yang paling lama
   b. Backup otomatis dulu
   c. Hapus semua data terkait (cascade)
   d. Create course baru
4. Jika 2 dan keduanya pinned → tolak dengan pesan
```

---

## 6. Database Schema (25+ Tabel)

### 6.1 Core Content Tables
- `courses` — data course (id, code, name, languages, timestamps)
- `levels` — level dalam course (id, course_id, number, cefr, min_xp)
- `units` — unit dalam level (id, level_id, number, name, order)
- `lessons` — lesson dalam unit (id, unit_id, type, xp_reward, durasi)

### 6.2 Vocabulary & Grammar
- `vocab` — super complete vocab dengan 60+ kolom (infleksi, sinonim JSON, dll)
- `vocab_fts` — FTS5 index untuk full-text search
- `grammar` — grammar points with correct/incorrect examples

### 6.3 Dialogue, Quiz, Stories
- `dialogues` + `dialogue_lines` — percakapan multi-speaker
- `quiz_questions` — MCQ, typing, matching, ordering, listening
- `stories` + `story_panels` + `story_questions` — komik interaktif

### 6.4 Learning & Progress
- `user_lesson_progress` — status, best_score, attempts, time
- `user_quiz_attempts` — setiap jawaban user
- `user_vocab_sr` — SM-2 spaced repetition (stage, ease_factor, interval)
- `user_mistakes` — mistake journal (type, count, rule)
- `user_streak` + `user_streak_history` — streak tracking
- `user_xp_log` + `user_gems` + `user_gems_log` — ekonomi
- `achievements` + `user_achievements` — badge system

### 6.5 Chat & Writing
- `chat_sessions` + `chat_messages` — AI tutor history
- `writing_history` — writing corrector history

### 6.6 Reading & Cache
- `reading_history` — artikel yang dibaca user
- `vocab_suggestions` — related vocab dari DDG

### 6.7 Tracking & Cache
- `course_access_tracking` — LRU tracking (last_accessed_at, is_pinned)
- `ai_cache` — response cache (model, response_json, expires_at)

---

## 7. AI Provider System

### 7.1 Supported Providers

| Provider | Base URL | Default Model |
|---|---|---|
| OpenRouter | https://openrouter.ai/api/v1 | anthropic/claude-sonnet-4-20250514 |
| Groq | https://api.groq.com/openai/v1 | llama-3.3-70b-versatile |
| xAI (Grok) | https://api.x.ai/v1 | grok-2-latest |
| DeepSeek | https://api.deepseek.com | deepseek-chat |
| Together AI | https://api.together.xyz/v1 | meta-llama/Llama-3.3-70B |
| Ollama | http://localhost:11434/v1 | llama3 |
| Custom | User input | User input |

### 7.2 API Adapter
- Satu adapter universal untuk semua provider (OpenAI-compatible)
- Endpoint: `POST {base_url}/chat/completions`
- Request: `{ model, messages: [{role, content}], response_format: { type: "json_object" } }`
- Error handling: retry 3x, timeout 30 detik
- Streaming: opsional, untuk AI Chat

### 7.3 Prompt Strategy
**System prompt** untuk super complete response:
- Instruction ketat format JSON
- Schema lengkap dengan semua field
- Bahasa yang konsisten
- Fallback jika data tidak tersedia (isi `null`)

---

## 8. DuckDuckGo Integration

### 8.1 Endpoint
```
GET https://api.duckduckgo.com/
  ?q={query}
  &format=json
  &no_html=1
  &skip_disambig=1
```

### 8.2 Feature Mapping

| Fitur | Query Pattern | Data yang Diambil |
|---|---|---|
| Quick Definition | `define+{word}` | Definition, Abstract, Image |
| Image Flashcard | `{word}+{language}` | Image URL (parsing) |
| Related Vocab | `{word}` | RelatedTopics, Infobox |
| Reading Mode | `simple+{topic}+for+beginner` | Snippet, URL, Title |

### 8.3 Caching
- Semua response DDG disimpan di `ai_cache` table
- TTL: 7 hari (definisi jarang berubah)
- Key: hash dari query + timestamp_hari

---

## 9. Gamification System

### 9.1 XP & Level

| Aktivitas | XP |
|---|---|
| Lesson selesai | +10 XP |
| Perfect score (100%) | +5 XP bonus |
| Streak harian | +5 XP |
| Achievement unlock | +50-200 XP |
| Boss Battle win | +100 XP |
| Quiz (per soal benar) | +5 XP |

### 9.2 Streak
- Hitung berdasarkan `user_streak_history.date`
- Streak putus jika lewat 1 hari tanpa aktivitas
- Streak freeze: item yang bisa dipakai untuk skip sehari
- Notifikasi reminder harian

### 9.3 Achievement Categories
- General: first_step, perfect_10, speed_demon
- Streak: 7_day, 30_day, 365_day
- Vocab: 100_words, 1000_words, master_100
- Quiz: perfect_quiz, no_hints, speed_run
- Social: first_share, first_card
- Hidden: easter_egg achievements

### 9.4 Spaced Repetition (SM-2)
```dart
stage 0: interval = 1 hari
stage 1: interval = 3 hari
stage 2+: interval = previous * ease_factor

ease_factor min: 1.3
ease_factor start: 2.5

quality >= 3 (benar): naik stage, perbesar interval
quality < 3 (salah): reset ke stage 0, interval 1 hari
```

---

## 10. UI/UX Design

### 10.1 Design Principles
- **Duolingo-inspired**: colorful, playful, rounded, animated
- **Consistent**: satu design system di seluruh app
- **Responsive**: adapt ke layar kecil (HP) dan besar (tablet)
- **Dark mode support**: semua warna punya light + dark variant

### 10.2 Color Palette
```
Primary:   #FF6B35 (orange)
Secondary: #4ECDC4 (teal)
Success:   #2ECC71 (green)
Error:     #E74C3C (red)
Warning:   #F39C12 (amber)
Info:      #3498DB (blue)

POS Colors:
  Verb:     #9B59B6 (purple)
  Noun:     #3498DB (blue)
  Adjective:#2ECC71 (green)
  Adverb:   #E67E22 (orange)
  Other:    #95A5A6 (grey)
```

### 10.3 Bottom Sheet Kata
- Collapsible sections dengan warna card berbeda
- Sinonim → Hijau, Antonim → Merah, Infleksi → Biru, Mengapa kata ini → Orange
- Loading state: shimmer → Quick Card → Full Card expand animasi
- Setiap kata bisa di-tap untuk dengar audio (TTS)

---

## 11. Build & Deployment

### 11.1 GitHub Actions Workflow

```yaml
Trigger:
  - Push tag v* (e.g. v1.0.0)
  - Manual trigger (workflow_dispatch)

Jobs:
  1. Checkout source
  2. Setup Java 17
  3. Setup Flutter 3.24.x (cached)
  4. flutter pub get
  5. dart run build_runner build
  6. flutter analyze
  7. flutter build apk --debug
  8. Build release APK (sign with keystore from secrets)
  9. Upload debug APK sebagai artifact
  10. Upload release APK ke GitHub Releases
```

### 11.2 Persiapan User

| Item | Keterangan |
|---|---|
| GitHub Repo | Buat repo `llanguage`, clone ke HP |
| Keystore | Generate `llanguage-keystore.jks` (keytool) |
| GitHub Secrets | KEYSTORE_BASE64, KEY_ALIAS, KEY_PASSWORD, STORE_PASSWORD |
| ACode/CodeStudio | Editor kode di HP |
| Git | Built-in di editor atau via Termux |

### 11.3 Development Flow

```
1. Edit kode di HP (ACode)
2. git add + commit + push ke main
3. Testing: workflow_dispatch manual untuk build
4. Siap rilis: git tag v1.0.0 && git push origin v1.0.0
5. GitHub Actions build → APK release di GitHub Releases
6. Download APK dari release, install di HP
```

---

## 12. Offline Strategy

| Level | Fitur Berjalan | Butuh Internet |
|---|---|---|
| **Full Offline** | Flashcard, Quiz, Review, Progress, Streak, SR, Grammar, Stats | ❌ |
| **Full Offline** | Mistake Journal, Focus Mode, Local Leaderboard, Export | ❌ |
| **Full Offline** | Book Reader, Dark Mode, Theme, Widget, Voice Commands | ❌ |
| **Partial Offline** | TTS Audio (setelah di-generate) | ❌ (setelah cache) |
| **Partial Offline** | AI Chat, Writing Corrector (history lokal, chat butuh AI) | ✅ (kecuali Ollama lokal) |
| **Partial Offline** | Deep Translation (cache lokal, translate baru butuh AI) | ✅ (kecuali Ollama lokal) |
| **Always Online** | Quick Definition baru (DDG), gambar baru (DDG) | ✅ |
| **Always Online** | Generate course baru, dowload gambar baru | ✅ |

---

## 13. Roadmap Prioritas

### Phase 1: Foundation
- Setup Flutter project + folder structure
- Drift database schema (semua tabel)
- Core services (theme, router, DI, secure storage)
- AI Provider adapter
- DuckDuckGo service

### Phase 2: Core Learning
- Deep Translation + Quick Definition
- Course system + Lesson player + Flashcard
- Quiz engine (MCQ, typing, matching, listening)
- Gamification (XP, streak, achievement, gems)
- Spaced Repetition (SM-2)

### Phase 3: DuckDuckGo Features
- Reading Mode (DDG article search + tappable text)
- Image Flashcard (DDG image download + cache)
- Related Vocab Suggestions

### Phase 4: Advanced AI
- AI Tutor Chat + Writing Corrector
- Skill Tree + Boss Battle + Season Pass
- Mistake Journal + Weekly Report
- Backup/Restore + Export
- Language-specific features

### Phase 5: Polish
- Widget + Notifications + Voice Commands
- Dark mode + Custom theme + Animations
- GitHub Actions final workflow
- Testing + Bug fixes

---

## 14. Resource Estimates

### Storage Development (Cloud Build)
| Item | Size |
|---|---|
| Source code | ~5-15 MB |
| ACode/CodeStudio | ~10-20 MB |
| **Total di HP** | **~20-40 MB** |

### APK Size
| Tipe | Size |
|---|---|
| Debug APK | ~30-50 MB |
| Release APK (per ABI) | ~15-25 MB |

### Runtime Storage di HP
| Item | Size |
|---|---|
| Database + progress (2 course) | ~3-5 MB |
| Audio TTS cache | ~5-15 MB |
| Gambar DDG cache | ~10-30 MB |
| AI cache | ~10-50 MB |
| **Total** | **~50-150 MB** |
