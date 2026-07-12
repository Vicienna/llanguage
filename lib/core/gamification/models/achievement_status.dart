class AchievementStatus {
  final int id;
  final String title;
  final String description;
  final String category;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final bool isNew;

  const AchievementStatus({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.isUnlocked,
    this.unlockedAt,
    this.isNew = false,
  });
}
