import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/providers/app_state_provider.dart';
import '../../../shared/models/leaderboard_model.dart';
import '../../../shared/widgets/app_card.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leaderboard = ref.watch(leaderboardProvider);
    final user = ref.watch(userProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final top3 = leaderboard.take(3).toList();
    final remainingUsers = leaderboard.skip(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peringkat Belajar (Leaderboard)'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'Global'),
            Tab(text: 'Mingguan (WIB)'),
            Tab(text: 'Bulanan'),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              _buildLeaderboardList(context, top3, remainingUsers, isDark),
              _buildLeaderboardList(context, top3, remainingUsers, isDark),
              _buildLeaderboardList(context, top3, remainingUsers, isDark),
            ],
          ),
          // Sticky Bottom Card for Current User Position (PRD AC-13)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.primary,
              shadows: const [
                BoxShadow(
                  color: Color(0x332563EB),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '#${user.rankGlobal}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Kamu (Posisi Saat Ini)',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Level ${user.level} • ${user.levelTitle}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${user.totalXp} XP',
                    style: const TextStyle(
                      color: AppColors.xpRewardDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList(
    BuildContext context,
    List<LeaderboardUser> top3,
    List<LeaderboardUser> remainingUsers,
    bool isDark,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 90),
      child: Column(
        children: [
          // Podium for Top 3
          if (top3.length >= 3) _buildPodium(top3, isDark),
          const SizedBox(height: 24),
          // Remaining rows
          ...remainingUsers.map((u) {
            return AppCard(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: u.isCurrentUser ? Border.all(color: AppColors.primary, width: 2) : null,
              child: Row(
                children: [
                  SizedBox(
                    width: 28,
                    child: Text(
                      '#${u.rank}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primaryContainer,
                    child: Text(
                      u.username[0].toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          u.username,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          'Level ${u.level}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (u.rankChange != 0) ...[
                    Icon(
                      u.rankChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                      color: u.rankChange > 0 ? AppColors.success : AppColors.error,
                      size: 20,
                    ),
                    Text(
                      '${u.rankChange.abs()}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: u.rankChange > 0 ? AppColors.success : AppColors.error,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    '${u.xp} XP',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.xpReward,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPodium(List<LeaderboardUser> top3, bool isDark) {
    final first = top3[0];
    final second = top3[1];
    final third = top3[2];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Rank 2: Silver
        _buildPodiumPillar(second, 2, 110, const Color(0xFF94A3B8), '🥈', isDark),
        const SizedBox(width: 12),
        // Rank 1: Gold
        _buildPodiumPillar(first, 1, 140, const Color(0xFFF59E0B), '👑', isDark),
        const SizedBox(width: 12),
        // Rank 3: Bronze
        _buildPodiumPillar(third, 3, 90, const Color(0xFFD97706), '🥉', isDark),
      ],
    );
  }

  Widget _buildPodiumPillar(
    LeaderboardUser user,
    int rank,
    double height,
    Color accentColor,
    String badgeEmoji,
    bool isDark,
  ) {
    return Column(
      children: [
        Text(badgeEmoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        CircleAvatar(
          radius: rank == 1 ? 26 : 22,
          backgroundColor: accentColor.withValues(alpha: 0.2),
          child: Text(
            user.username[0].toUpperCase(),
            style: TextStyle(
              fontSize: rank == 1 ? 18 : 16,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          user.username,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          '${user.xp} XP',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: accentColor),
        ),
        const SizedBox(height: 8),
        Container(
          width: 84,
          height: height,
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.15),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusMd)),
            border: Border.all(color: accentColor.withValues(alpha: 0.4)),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
