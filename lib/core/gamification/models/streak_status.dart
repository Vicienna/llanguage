class StreakStatus {
  final int currentStreak;
  final int longestStreak;
  final DateTime lastActiveDate;
  final int frozenDays;
  final bool isActive;

  const StreakStatus({
    required this.currentStreak,
    required this.longestStreak,
    required this.lastActiveDate,
    this.frozenDays = 0,
    required this.isActive,
  });
}
