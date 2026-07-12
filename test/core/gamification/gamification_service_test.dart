import 'package:flutter_test/flutter_test.dart';
import 'package:llanguage/data/database/daos/gamification_dao.dart';
import 'package:llanguage/core/gamification/gamification_service.dart';
import 'package:mocktail/mocktail.dart';

class MockGamificationDao extends Mock implements GamificationDao {}

void main() {
  late MockGamificationDao dao;
  late GamificationService service;

  setUpAll(() {
    registerFallbackValue(DateTime.now());
    registerFallbackValue(UserStreakData(
      id: 0, currentStreak: 0, longestStreak: 0,
      lastActiveDate: DateTime(0), frozenDays: 0,
    ));
    registerFallbackValue(UserStreakHistoryData(
      id: 0, date: DateTime.now(), isActive: true, streakAtThatTime: 0,
    ));
    registerFallbackValue(UserXpLogData(
      id: 0, amount: 0, reason: '', createdAt: DateTime.now(),
    ));
    registerFallbackValue(UserGemsLogData(
      id: 0, amount: 0, reason: '', type: '', createdAt: DateTime.now(),
    ));
  });

  setUp(() {
    dao = MockGamificationDao();
    service = GamificationService(dao);
  });

  group('getXpSummary', () {
    test('returns summary from dao', () async {
      when(() => dao.getTotalXp()).thenAnswer((_) async => 150);
      when(() => dao.getGems()).thenAnswer((_) async => UserGem(
        id: 1, balance: 50, lifetimeEarned: 100,
      ));

      final summary = await service.getXpSummary();
      expect(summary.totalXp, equals(150));
      expect(summary.gemsBalance, equals(50));
      expect(summary.gemsLifetimeEarned, equals(100));
    });

    test('returns zeros when no gems row', () async {
      when(() => dao.getTotalXp()).thenAnswer((_) async => 0);
      when(() => dao.getGems()).thenAnswer((_) async => null);

      final summary = await service.getXpSummary();
      expect(summary.gemsBalance, equals(0));
    });
  });

  group('getStreakStatus', () {
    test('returns inactive when no streak', () async {
      when(() => dao.getStreak()).thenAnswer((_) async => null);

      final status = await service.getStreakStatus();
      expect(status.isActive, isFalse);
      expect(status.currentStreak, equals(0));
    });

    test('returns active when last active today', () async {
      final today = DateTime.now();
      when(() => dao.getStreak()).thenAnswer((_) async => UserStreakData(
        id: 1, currentStreak: 5, longestStreak: 10,
        lastActiveDate: today, frozenDays: 0,
      ));

      final status = await service.getStreakStatus();
      expect(status.isActive, isTrue);
      expect(status.currentStreak, equals(5));
    });
  });

  group('checkIn', () {
    test('inits streak on first check-in', () async {
      when(() => dao.getStreak()).thenAnswer((_) async => null);
      when(() => dao.initStreak(any())).thenAnswer((_) async => UserStreakData(
        id: 1, currentStreak: 0, longestStreak: 0,
        lastActiveDate: DateTime.now(), frozenDays: 0,
      ));
      when(() => dao.updateStreak(
        currentStreak: any(named: 'currentStreak'),
        longestStreak: any(named: 'longestStreak'),
        lastActiveDate: any(named: 'lastActiveDate'),
      )).thenAnswer((_) async => [UserStreakData(
        id: 1, currentStreak: 1, longestStreak: 1,
        lastActiveDate: DateTime.now(), frozenDays: 0,
      )]);
      when(() => dao.addStreakHistory(
        date: any(named: 'date'),
        isActive: any(named: 'isActive'),
        streakAtThatTime: any(named: 'streakAtThatTime'),
      )).thenAnswer((_) async => UserStreakHistoryData(
        id: 1, date: DateTime.now(), isActive: true, streakAtThatTime: 1,
      ));

      final status = await service.checkIn();
      expect(status.currentStreak, equals(1));
      expect(status.longestStreak, equals(1));
      verify(() => dao.initStreak(any())).called(1);
    });

    test('increments streak on consecutive day', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      when(() => dao.getStreak()).thenAnswer((_) async => UserStreakData(
        id: 1, currentStreak: 3, longestStreak: 5,
        lastActiveDate: yesterday, frozenDays: 0,
      ));
      when(() => dao.updateStreak(
        currentStreak: any(named: 'currentStreak'),
        longestStreak: any(named: 'longestStreak'),
        lastActiveDate: any(named: 'lastActiveDate'),
      )).thenAnswer((_) async => [UserStreakData(
        id: 1, currentStreak: 4, longestStreak: 5,
        lastActiveDate: DateTime.now(), frozenDays: 0,
      )]);
      when(() => dao.addStreakHistory(
        date: any(named: 'date'),
        isActive: any(named: 'isActive'),
        streakAtThatTime: any(named: 'streakAtThatTime'),
      )).thenAnswer((_) async => UserStreakHistoryData(
        id: 1, date: DateTime.now(), isActive: true, streakAtThatTime: 4,
      ));

      final status = await service.checkIn();
      expect(status.currentStreak, equals(4));
    });

    test('resets streak after missing more than 1 day without freeze', () async {
      final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
      when(() => dao.getStreak()).thenAnswer((_) async => UserStreakData(
        id: 1, currentStreak: 10, longestStreak: 10,
        lastActiveDate: threeDaysAgo, frozenDays: 0,
      ));
      when(() => dao.updateStreak(
        currentStreak: any(named: 'currentStreak'),
        longestStreak: any(named: 'longestStreak'),
        lastActiveDate: any(named: 'lastActiveDate'),
      )).thenAnswer((_) async => [UserStreakData(
        id: 1, currentStreak: 1, longestStreak: 10,
        lastActiveDate: DateTime.now(), frozenDays: 0,
      )]);
      when(() => dao.addStreakHistory(
        date: any(named: 'date'),
        isActive: any(named: 'isActive'),
        streakAtThatTime: any(named: 'streakAtThatTime'),
      )).thenAnswer((_) async => UserStreakHistoryData(
        id: 1, date: DateTime.now(), isActive: true, streakAtThatTime: 1,
      ));

      final status = await service.checkIn();
      expect(status.currentStreak, equals(1));
      expect(status.longestStreak, equals(10));
    });
  });

  group('addXp', () {
    test('delegates to dao', () async {
      when(() => dao.addXp(
        amount: any(named: 'amount'),
        reason: any(named: 'reason'),
        createdAt: any(named: 'createdAt'),
      )).thenAnswer((_) async => UserXpLogData(
        id: 1, amount: 50, reason: 'quiz', createdAt: DateTime.now(),
      ));

      await service.addXp(50, 'quiz');
      verify(() => dao.addXp(amount: 50, reason: 'quiz', createdAt: any(named: 'createdAt'))).called(1);
    });
  });
}
