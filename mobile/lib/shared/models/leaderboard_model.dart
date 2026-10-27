class LeaderboardUser {
  final int rank;
  final String username;
  final String? avatarUrl;
  final int level;
  final int xp;
  final int rankChange; // + positive, - negative, 0 same
  final bool isCurrentUser;

  const LeaderboardUser({
    required this.rank,
    required this.username,
    this.avatarUrl,
    required this.level,
    required this.xp,
    required this.rankChange,
    this.isCurrentUser = false,
  });
}
