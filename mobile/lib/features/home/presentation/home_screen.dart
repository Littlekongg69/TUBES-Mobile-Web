import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/providers/app_state_provider.dart';
import '../../../shared/models/learning_models.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/xp_progress_bar.dart';
import '../../../shared/widgets/streak_chip.dart';
import '../../../shared/widgets/week_streak_row.dart';
import '../../../shared/widgets/stat_tile.dart';
import '../../../shared/widgets/mission_banner.dart';
import '../../../shared/widgets/module_card.dart';

class HomeScreen extends ConsumerWidget {
  final ValueChanged<int> onNavigateTab;

  const HomeScreen({super.key, required this.onNavigateTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final modules = ref.watch(modulesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.darkBackgroundGradientStart, AppColors.darkBackgroundGradientEnd]
                : [AppColors.lightBackgroundGradientStart, AppColors.lightBackgroundGradientEnd],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                // 1. Header "Beranda" + Tagline + Profile Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Beranda',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          'Siap kuasai SQL hari ini?',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => onNavigateTab(3), // Switch to Profile Tab
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primaryContainer,
                          child: const Text('👨‍💻', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 2. Kartu Sapaan: Hai, {nama}, Level & XP Bar, Streak Chip
                AppCard(
                  padding: const EdgeInsets.all(AppDimensions.base),
                  color: isDark ? AppColors.darkCardSurface : Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryContainer,
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                                ),
                                child: Text(
                                  'Level ${user.level} • ${user.levelTitle}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          StreakChip(streakDays: user.currentStreak),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Hai, ${user.fullName} 👋',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      XpProgressBar(
                        currentXp: user.totalXp,
                        targetXp: user.xpForNextLevel,
                        showLabel: true,
                        height: 12,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Tantangan Harian (Daily Mission Banner)
                MissionBanner(
                  title: 'Bantu Chef Mario di SQL Cooking Quest',
                  subtitle: 'Selesaikan pesanan query untuk bonus XP ekstra!',
                  xpReward: 100,
                  onTap: () => context.push('/daily-missions'),
                ),
                const SizedBox(height: 16),

                // 4. Minggu Ini (7-Day Streak Row)
                WeekStreakRow(
                  weekDays: user.weekStreakDays,
                  currentStreak: user.currentStreak,
                ),
                const SizedBox(height: 16),

                // 5. Statistik Cepat (Akurasi & Misi Selesai)
                Row(
                  children: [
                    Expanded(
                      child: StatTile(
                        label: 'Akurasi Kueri',
                        value: '${user.accuracyPercent}%',
                        icon: Icons.track_changes_rounded,
                        iconColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatTile(
                        label: 'Misi Selesai',
                        value: '${user.completedMissions} Misi',
                        icon: Icons.military_tech_rounded,
                        iconColor: AppColors.xpReward,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 6. Kartu Peringkat (Leaderboard Preview)
                AppCard(
                  onTap: () => context.push('/leaderboard'),
                  padding: const EdgeInsets.all(AppDimensions.base),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                        ),
                        child: const Text('🏆', style: TextStyle(fontSize: 22)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Peringkat Global',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Kamu berada di Rank #${user.rankGlobal}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              'Top 3: dimas_postgres, sarah_data, budi',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 7. Lanjutkan Belajar Header & List
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lanjutkan Belajar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => onNavigateTab(1), // Go to Belajar tab
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...modules.take(3).map((mod) {
                  return ModuleCard(
                    module: mod,
                    onTap: () {
                      if (mod.status == ModuleStatus.locked) {
                        _showLockedBottomSheet(context, mod.prerequisiteTitle ?? 'Modul sebelumnya');
                      } else {
                        onNavigateTab(1); // Open learning tab
                      }
                    },
                  );
                }),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLockedBottomSheet(BuildContext context, String prerequisite) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFFFEE2E2),
                  child: Icon(Icons.lock_rounded, size: 32, color: AppColors.error),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Modul Terkunci 🔒',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kamu harus menyelesaikan modul prasyarat berikut terlebih dahulu untuk membuka materi ini:\n\n• $prerequisite',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Mengerti'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
