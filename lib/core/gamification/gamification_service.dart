import '../../data/database/daos/gamification_dao.dart';
import 'models/streak_status.dart';
import 'models/xp_summary.dart';
import 'models/achievement_status.dart';

class GamificationService {
  final GamificationDao _dao;

  GamificationService(this._dao);

  Future<XpSummary> getXpSummary() async {
    final totalXp = await _dao.getTotalXp();
    final gems = await _dao.getGems();
    return XpSummary(
      totalXp: totalXp,
      gemsBalance: gems?.balance ?? 0,
      gemsLifetimeEarned: gems?.lifetimeEarned ?? 0,
    );
  }

  Future<StreakStatus> getStreakStatus() async {
    final streak = await _dao.getStreak();
    if (streak == null) {
      const status = StreakStatus(
        currentStreak: 0,
        longestStreak: 0,
        lastActiveDate: DateTime(0),
        isActive: false,
      );
      return status;
    }
    final now = DateTime.now();
    final diff = now.difference(streak.lastActiveDate).inDays;
    return StreakStatus(
      currentStreak: streak.currentStreak,
      longestStreak: streak.longestStreak,
      lastActiveDate: streak.lastActiveDate,
      frozenDays: streak.frozenDays,
      isActive: diff <= 1,
    );
  }

  Future<StreakStatus> checkIn() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    var streak = await _dao.getStreak();
    if (streak == null) {
      await _dao.initStreak(today);
      await _dao.updateStreak(
        currentStreak: 1,
        longestStreak: 1,
        lastActiveDate: today,
      );
      await _dao.addStreakHistory(
        date: today,
        isActive: true,
        streakAtThatTime: 1,
      );
      return StreakStatus(
        currentStreak: 1,
        longestStreak: 1,
        lastActiveDate: today,
        isActive: true,
      );
    }

    final lastActive = DateTime(
      streak.lastActiveDate.year,
      streak.lastActiveDate.month,
      streak.lastActiveDate.day,
    );
    final diff = today.difference(lastActive).inDays;

    int newCurrent = streak.currentStreak;
    int newLongest = streak.longestStreak;

    if (diff == 0) {
    } else if (diff == 1) {
      newCurrent += 1;
      if (newCurrent > newLongest) newLongest = newCurrent;
    } else if (diff == 2 && streak.frozenDays > 0) {
      newCurrent += 1;
      if (newCurrent > newLongest) newLongest = newCurrent;
      await _dao.updateStreak(
        currentStreak: streak.currentStreak,
        longestStreak: streak.longestStreak,
        lastActiveDate: streak.lastActiveDate,
        frozenDays: streak.frozenDays - 1,
      );
    } else {
      newCurrent = 1;
    }

    await _dao.updateStreak(
      currentStreak: newCurrent,
      longestStreak: newLongest,
      lastActiveDate: today,
    );

    await _dao.addStreakHistory(
      date: today,
      isActive: true,
      streakAtThatTime: newCurrent,
    );

    return StreakStatus(
      currentStreak: newCurrent,
      longestStreak: newLongest,
      lastActiveDate: today,
      frozenDays: streak.frozenDays,
      isActive: true,
    );
  }

  Future<void> addXp(int amount, String reason) async {
    await _dao.addXp(amount: amount, reason: reason, createdAt: DateTime.now());
  }

  Future<void> earnGems(int amount, String reason) async {
    final existing = await _dao.getGems();
    if (existing == null) await _dao.initGems();
    await _dao.addGems(amount: amount, reason: reason, createdAt: DateTime.now());
  }

  Future<List<AchievementStatus>> getAchievements() async {
    final all = await _dao.getAllAchievements();
    final unlocked = await _dao.getUserAchievements();
    final unlockedMap = {for (final u in unlocked) u.achievementId: u};

    return all.map((a) {
      final u = unlockedMap[a.id];
      return AchievementStatus(
        id: a.id,
        title: a.title,
        description: a.description,
        category: a.category,
        isUnlocked: u != null,
        unlockedAt: u?.unlockedAt,
        isNew: u?.isNew ?? false,
      );
    }).toList();
  }
}
