class UserModel {
  final String id;
  final String username;
  final String fullName;
  final String? avatarUrl;
  final int level;
  final String levelTitle;
  final int totalXp;
  final int xpForNextLevel;
  final int currentStreak;
  final int longestStreak;
  final int rankGlobal;
  final String role;
  final int completedModules;
  final int totalModules;
  final int completedMissions;
  final double accuracyPercent;
  final List<bool> weekStreakDays; // Mon - Sun (7 days)

  const UserModel({
    required this.id,
    required this.username,
    required this.fullName,
    this.avatarUrl,
    required this.level,
    required this.levelTitle,
    required this.totalXp,
    required this.xpForNextLevel,
    required this.currentStreak,
    required this.longestStreak,
    required this.rankGlobal,
    required this.role,
    this.completedModules = 2,
    this.totalModules = 8,
    this.completedMissions = 14,
    this.accuracyPercent = 85.0,
    this.weekStreakDays = const [true, true, true, true, true, false, false],
  });

  // Calculate cumulative XP needed for level L: 50 * L * (L - 1)
  static int cumulativeXpForLevel(int level) {
    return 50 * level * (level - 1);
  }

  // Calculate XP needed to reach next level: 100 * level
  static int xpNeededForNextLevel(int currentLevel) {
    return 100 * currentLevel;
  }

  static String getTitleForLevel(int level) {
    if (level <= 1) return 'SQL Beginner';
    if (level == 2) return 'Query Learner';
    if (level == 3) return 'Query Explorer';
    if (level == 4) return 'SQL Practitioner';
    if (level == 5) return 'SQL Specialist';
    return 'SQL Master';
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? fullName,
    String? avatarUrl,
    int? level,
    String? levelTitle,
    int? totalXp,
    int? xpForNextLevel,
    int? currentStreak,
    int? longestStreak,
    int? rankGlobal,
    String? role,
    int? completedModules,
    int? totalModules,
    int? completedMissions,
    double? accuracyPercent,
    List<bool>? weekStreakDays,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      levelTitle: levelTitle ?? this.levelTitle,
      totalXp: totalXp ?? this.totalXp,
      xpForNextLevel: xpForNextLevel ?? this.xpForNextLevel,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      rankGlobal: rankGlobal ?? this.rankGlobal,
      role: role ?? this.role,
      completedModules: completedModules ?? this.completedModules,
      totalModules: totalModules ?? this.totalModules,
      completedMissions: completedMissions ?? this.completedMissions,
      accuracyPercent: accuracyPercent ?? this.accuracyPercent,
      weekStreakDays: weekStreakDays ?? this.weekStreakDays,
    );
  }
}
