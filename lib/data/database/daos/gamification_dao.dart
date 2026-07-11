import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/all_tables.dart';

part 'gamification_dao.g.dart';

@DriftAccessor(tables: [UserXpLog, UserGems, UserGemsLog, UserStreak, UserStreakHistory, Achievements, UserAchievements])
class GamificationDao extends DatabaseAccessor<AppDatabase> with _$GamificationDaoMixin {
  final AppDatabase db;

  GamificationDao(this.db) : super(db);

  Future<UserXpLogData> addXp({
    required int amount,
    required String reason,
    required DateTime createdAt,
  }) =>
      db.into(db.userXpLog).insertReturning(UserXpLogCompanion.insert(
        amount: amount,
        reason: reason,
        createdAt: createdAt,
      ));

  Future<int> getTotalXp() async {
    final result = await (db.selectOnly(db.userXpLog)
          ..addColumns([db.userXpLog.amount.sum()]))
        .getSingle();
    return result.read(db.userXpLog.amount.sum()) ?? 0;
  }

  Future<List<UserXpLogData>> getXpLog() => db.select(db.userXpLog).get();

  Future<UserGemData> initGems() =>
      db.into(db.userGems).insertReturning(UserGemsCompanion.insert(
        balance: 0,
        lifetimeEarned: 0,
      ));

  Future<UserGemData> addGems({
    required int amount,
    required String reason,
    required DateTime createdAt,
  }) async {
    await db.into(db.userGemsLog).insertReturning(UserGemsLogCompanion.insert(
      amount: amount,
      reason: reason,
      type: 'earn',
      createdAt: createdAt,
    ));
    final current = await (db.select(db.userGems)..where((t) => t.id.equals(1))).getSingle();
    return (db.update(db.userGems)..where((t) => t.id.equals(1))).writeReturning(
      UserGemsCompanion(
        balance: Value(current.balance + amount),
        lifetimeEarned: Value(current.lifetimeEarned + amount),
      ),
    );
  }

  Future<UserGemData> spendGems({
    required int amount,
    required String reason,
    required DateTime createdAt,
  }) async {
    await db.into(db.userGemsLog).insertReturning(UserGemsLogCompanion.insert(
      amount: amount,
      reason: reason,
      type: 'spend',
      createdAt: createdAt,
    ));
    final current = await (db.select(db.userGems)..where((t) => t.id.equals(1))).getSingle();
    return (db.update(db.userGems)..where((t) => t.id.equals(1))).writeReturning(
      UserGemsCompanion(
        balance: Value(current.balance - amount),
      ),
    );
  }

  Future<UserGemData?> getGems() =>
      (db.select(db.userGems)..where((t) => t.id.equals(1))).getSingleOrNull();

  Future<List<UserGemsLogData>> getGemsLog() => db.select(db.userGemsLog).get();

  Future<UserStreakData> initStreak(DateTime now) =>
      db.into(db.userStreak).insertReturning(UserStreakCompanion.insert(
        currentStreak: 0,
        longestStreak: 0,
        lastActiveDate: now,
        frozenDays: 0,
      ));

  Future<UserStreakData> updateStreak({
    required int currentStreak,
    required int longestStreak,
    required DateTime lastActiveDate,
    int? frozenDays,
  }) =>
      (db.update(db.userStreak)..where((t) => t.id.equals(1))).writeReturning(
        UserStreakCompanion(
          currentStreak: Value(currentStreak),
          longestStreak: Value(longestStreak),
          lastActiveDate: Value(lastActiveDate),
          frozenDays: Value(frozenDays),
        ),
      );

  Future<UserStreakData?> getStreak() =>
      (db.select(db.userStreak)..where((t) => t.id.equals(1))).getSingleOrNull();

  Future<UserStreakHistoryData> addStreakHistory({
    required DateTime date,
    required bool isActive,
    required int streakAtThatTime,
  }) =>
      db.into(db.userStreakHistory).insertReturning(UserStreakHistoryCompanion.insert(
        date: date,
        isActive: isActive,
        streakAtThatTime: streakAtThatTime,
      ));

  Future<List<UserStreakHistoryData>> getStreakHistory() =>
      db.select(db.userStreakHistory).get();

  Future<AchievementData> createAchievement({
    required String title,
    required String description,
    String? iconUrl,
    required String category,
    required String requirementJson,
    int? rewardXp,
    int? rewardGems,
  }) =>
      db.into(db.achievements).insertReturning(AchievementsCompanion.insert(
        title: title,
        description: description,
        iconUrl: Value(iconUrl),
        category: category,
        requirementJson: requirementJson,
        rewardXp: Value(rewardXp),
        rewardGems: Value(rewardGems),
      ));

  Future<List<AchievementData>> getAllAchievements() => db.select(db.achievements).get();

  Future<UserAchievementData> unlockAchievement({
    required int achievementId,
    required DateTime unlockedAt,
  }) =>
      db.into(db.userAchievements).insertReturning(UserAchievementsCompanion.insert(
        achievementId: achievementId,
        unlockedAt: unlockedAt,
        isNew: true,
      ));

  Future<List<UserAchievementData>> getUserAchievements() =>
      db.select(db.userAchievements).get();
}
