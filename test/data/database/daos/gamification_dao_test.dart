import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:llanguage/data/database/app_database.dart';
import 'package:llanguage/data/database/daos/gamification_dao.dart';
import 'package:llanguage/data/database/tables/all_tables.dart';

void main() {
  late AppDatabase database;
  late GamificationDao dao;

  setUp(() {
    database = AppDatabase.forTest(NativeDatabase.memory());
    dao = GamificationDao(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('GamificationDao - XP', () {
    test('addXp creates an XP log entry', () async {
      final now = DateTime.now();
      final xp = await dao.addXp(amount: 50, reason: 'completed_lesson', createdAt: now);
      expect(xp.id, isNotNull);
      expect(xp.amount, equals(50));
    });

    test('getTotalXp sums all XP', () async {
      final now = DateTime.now();
      await dao.addXp(amount: 100, reason: 'lesson', createdAt: now);
      await dao.addXp(amount: 50, reason: 'quiz', createdAt: now);
      final total = await dao.getTotalXp();
      expect(total, equals(150));
    });

    test('getXpLog returns all entries', () async {
      final now = DateTime.now();
      await dao.addXp(amount: 10, reason: 'a', createdAt: now);
      await dao.addXp(amount: 20, reason: 'b', createdAt: now);
      final log = await dao.getXpLog();
      expect(log.length, equals(2));
    });
  });

  group('GamificationDao - Gems', () {
    test('initGems creates gems row', () async {
      final gems = await dao.initGems();
      expect(gems.balance, equals(0));
      expect(gems.lifetimeEarned, equals(0));
    });

    test('addGems increases balance and lifetime', () async {
      await dao.initGems();
      final now = DateTime.now();
      final gems = await dao.addGems(amount: 50, reason: 'achievement', createdAt: now);
      expect(gems.balance, equals(50));
      expect(gems.lifetimeEarned, equals(50));
    });

    test('spendGems decreases balance', () async {
      await dao.initGems();
      final now = DateTime.now();
      await dao.addGems(amount: 100, reason: 'earn', createdAt: now);
      final gems = await dao.spendGems(amount: 30, reason: 'purchase', createdAt: now);
      expect(gems.balance, equals(70));
    });

    test('getGems returns current state', () async {
      await dao.initGems();
      final now = DateTime.now();
      await dao.addGems(amount: 200, reason: 'test', createdAt: now);
      final gems = await dao.getGems();
      expect(gems!.balance, equals(200));
    });

    test('getGemsLog returns all gem transactions', () async {
      final now = DateTime.now();
      await dao.addGems(amount: 10, reason: 'a', createdAt: now);
      await dao.addGems(amount: 20, reason: 'b', createdAt: now);
      final log = await dao.getGemsLog();
      expect(log.length, equals(2));
    });
  });

  group('GamificationDao - Streak', () {
    test('initStreak creates streak row', () async {
      final now = DateTime.now();
      final streak = await dao.initStreak(now);
      expect(streak.currentStreak, equals(0));
      expect(streak.longestStreak, equals(0));
    });

    test('updateStreak updates values', () async {
      final now = DateTime.now();
      await dao.initStreak(now);
      final updated = await dao.updateStreak(currentStreak: 5, longestStreak: 5, lastActiveDate: now);
      expect(updated.currentStreak, equals(5));
    });

    test('getStreak returns current streak', () async {
      final now = DateTime.now();
      await dao.initStreak(now);
      await dao.updateStreak(currentStreak: 3, longestStreak: 10, lastActiveDate: now);
      final streak = await dao.getStreak();
      expect(streak!.currentStreak, equals(3));
      expect(streak.longestStreak, equals(10));
    });
  });

  group('GamificationDao - Achievements', () {
    test('createAchievement inserts an achievement', () async {
      final a = await dao.createAchievement(
        title: 'First Steps',
        description: 'Complete first lesson',
        category: 'milestone',
        requirementJson: '{}',
      );
      expect(a.id, isNotNull);
      expect(a.title, equals('First Steps'));
    });

    test('getAllAchievements returns all', () async {
      await dao.createAchievement(title: 'A', description: 'D', category: 'c', requirementJson: '{}');
      await dao.createAchievement(title: 'B', description: 'D', category: 'c', requirementJson: '{}');
      final all = await dao.getAllAchievements();
      expect(all.length, equals(2));
    });

    test('unlockAchievement creates user achievement', () async {
      final now = DateTime.now();
      final ach = await dao.createAchievement(title: 'A', description: 'D', category: 'c', requirementJson: '{}');
      final ua = await dao.unlockAchievement(achievementId: ach.id, unlockedAt: now);
      expect(ua.isNew, isTrue);
    });

    test('getUserAchievements returns unlocked ones', () async {
      final now = DateTime.now();
      final ach1 = await dao.createAchievement(title: 'A', description: 'D1', category: 'c', requirementJson: '{}');
      final ach2 = await dao.createAchievement(title: 'B', description: 'D2', category: 'c', requirementJson: '{}');
      await dao.unlockAchievement(achievementId: ach1.id, unlockedAt: now);
      await dao.unlockAchievement(achievementId: ach2.id, unlockedAt: now);
      final unlocked = await dao.getUserAchievements();
      expect(unlocked.length, equals(2));
    });
  });

  group('GamificationDao - Streak History', () {
    test('addStreakHistory creates entry', () async {
      final now = DateTime.now();
      final h = await dao.addStreakHistory(date: now, isActive: true, streakAtThatTime: 5);
      expect(h.id, isNotNull);
      expect(h.isActive, isTrue);
    });

    test('getStreakHistory returns all entries', () async {
      final now = DateTime.now();
      await dao.addStreakHistory(date: now.subtract(const Duration(days: 1)), isActive: true, streakAtThatTime: 3);
      await dao.addStreakHistory(date: now, isActive: true, streakAtThatTime: 4);
      final history = await dao.getStreakHistory();
      expect(history.length, equals(2));
    });
  });
}
