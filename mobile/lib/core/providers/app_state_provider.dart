import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/learning_models.dart';
import '../../shared/models/mission_model.dart';
import '../../shared/models/leaderboard_model.dart';
import '../../shared/widgets/badge_tile.dart';

// Current User State Notifier
final userProvider = NotifierProvider<UserNotifier, UserModel>(UserNotifier.new);

class UserNotifier extends Notifier<UserModel> {
  @override
  UserModel build() {
    return const UserModel(
      id: 'usr_001',
      username: 'kevin_sql',
      fullName: 'Kevin Kendra',
      avatarUrl: null,
      level: 3,
      levelTitle: 'Query Explorer',
      totalXp: 420,
      xpForNextLevel: 600,
      currentStreak: 5,
      longestStreak: 9,
      rankGlobal: 128,
      role: 'user',
      completedModules: 2,
      totalModules: 8,
      completedMissions: 14,
      accuracyPercent: 88.5,
      weekStreakDays: [true, true, true, true, true, false, false],
    );
  }

  void addXp(int amount) {
    final newTotalXp = state.totalXp + amount;
    int currentLevel = state.level;
    int nextLevelXp = state.xpForNextLevel;

    // Check level up formula: level L requires 50 * L * (L - 1)
    while (newTotalXp >= nextLevelXp) {
      currentLevel++;
      nextLevelXp = UserModel.cumulativeXpForLevel(currentLevel + 1);
    }

    state = state.copyWith(
      totalXp: newTotalXp,
      level: currentLevel,
      levelTitle: UserModel.getTitleForLevel(currentLevel),
      xpForNextLevel: nextLevelXp,
    );
  }

  void incrementCompletedMission() {
    state = state.copyWith(completedMissions: state.completedMissions + 1);
  }

  void updateProfile({required String fullName, required String username}) {
    state = state.copyWith(fullName: fullName, username: username);
  }
}

// Learning Modules State Provider
final modulesProvider = NotifierProvider<ModulesNotifier, List<ModuleModel>>(ModulesNotifier.new);

class ModulesNotifier extends Notifier<List<ModuleModel>> {
  @override
  List<ModuleModel> build() {
    return [
      const ModuleModel(
        id: 'mod_1',
        position: 1,
        title: 'Pengenalan Basis Data & SQL Dasar',
        description: 'Konsep database relasional, tabel, kolom, baris, dan query SELECT pertama.',
        estimatedMinutes: 20,
        status: ModuleStatus.completed,
        progress: 1.0,
        lessons: [
          LessonModel(
            id: 'les_1',
            moduleId: 'mod_1',
            position: 1,
            title: 'Apa itu Basis Data Relasional?',
            content:
                'Basis data relasional menyimpan data dalam bentuk tabel yang terdiri atas baris dan kolom. SQL (Structured Query Language) adalah bahasa standar untuk berinteraksi dengan basis data.',
            codeExample: '-- Contoh struktur tabel\nSELECT * FROM users;',
            estimatedMinutes: 5,
            xpReward: 20,
            isCompleted: true,
          ),
          LessonModel(
            id: 'les_2',
            moduleId: 'mod_1',
            position: 2,
            title: 'Query SELECT Sederhana',
            content:
                'Pernyataan SELECT digunakan untuk mengambil data dari satu atau lebih tabel. Tanda bintang (*) menandakan kita mengambil semua kolom.',
            codeExample: 'SELECT id, name, email FROM users;',
            estimatedMinutes: 10,
            xpReward: 25,
            isCompleted: true,
          ),
        ],
      ),
      const ModuleModel(
        id: 'mod_2',
        position: 2,
        title: 'Filter Data dengan Klausa WHERE',
        description: 'Menyaring baris data dengan operator pembanding (=, >, <, !=, LIKE, IN).',
        estimatedMinutes: 30,
        status: ModuleStatus.inProgress,
        progress: 0.60,
        lessons: [
          LessonModel(
            id: 'les_3',
            moduleId: 'mod_2',
            position: 1,
            title: 'Klausa WHERE Dasar',
            content:
                'Klausa WHERE digunakan untuk memfilter baris yang memenuhi kondisi tertentu sebelum dikembalikan oleh basis data.',
            codeExample: "SELECT * FROM products WHERE price > 50000;",
            estimatedMinutes: 10,
            xpReward: 30,
            isCompleted: true,
          ),
          LessonModel(
            id: 'les_4',
            moduleId: 'mod_2',
            position: 2,
            title: 'Operator Logika AND, OR, NOT',
            content:
                'Gabungkan beberapa kondisi logika untuk pencarian presisi tinggi pada baris data.',
            codeExample: "SELECT * FROM orders WHERE status = 'paid' AND total > 100000;",
            estimatedMinutes: 15,
            xpReward: 35,
            isCompleted: false,
          ),
        ],
      ),
      const ModuleModel(
        id: 'mod_3',
        position: 3,
        title: 'Pengurutan & Pembatasan Data (ORDER BY, LIMIT)',
        description: 'Mengatur urutan baris data secara ASC/DESC dan mengambil sejumlah baris teratas.',
        estimatedMinutes: 25,
        status: ModuleStatus.locked,
        progress: 0.0,
        prerequisiteTitle: 'Modul 02: Filter Data dengan Klausa WHERE',
      ),
      const ModuleModel(
        id: 'mod_4',
        position: 4,
        title: 'Fungsi Agregasi & GROUP BY',
        description: 'Menghitung COUNT, SUM, AVG, MIN, MAX dan mengelompokkan baris data.',
        estimatedMinutes: 35,
        status: ModuleStatus.locked,
        progress: 0.0,
        prerequisiteTitle: 'Modul 03: Pengurutan & Pembatasan Data',
      ),
      const ModuleModel(
        id: 'mod_5',
        position: 5,
        title: 'Relasi Antar Tabel (JOIN)',
        description: 'Menghubungkan data lintas tabel dengan INNER JOIN, LEFT JOIN, dan RIGHT JOIN.',
        estimatedMinutes: 45,
        status: ModuleStatus.locked,
        progress: 0.0,
        prerequisiteTitle: 'Modul 04: Fungsi Agregasi & GROUP BY',
      ),
    ];
  }

  void completeLesson(String moduleId, String lessonId) {
    state = [
      for (final mod in state)
        if (mod.id == moduleId)
          mod.copyWith(
            progress: 1.0,
            status: ModuleStatus.completed,
          )
        else
          mod
    ];
  }
}

// Daily Missions Provider
final missionsProvider = NotifierProvider<MissionsNotifier, List<DailyMissionModel>>(MissionsNotifier.new);

class MissionsNotifier extends Notifier<List<DailyMissionModel>> {
  @override
  List<DailyMissionModel> build() {
    return [
      const DailyMissionModel(
        id: 'mis_1',
        title: 'Selesaikan 1 Pelajaran Baru',
        description: 'Pelajari materi dan jalankan contoh kueri SQL di modul.',
        progress: 1,
        target: 1,
        xpReward: 50,
        isCompleted: true,
        isClaimed: false,
      ),
      const DailyMissionModel(
        id: 'mis_2',
        title: 'Jalankan 3 Kueri SQL di Mode Game',
        description: 'Uji kemampuan kuerimu dalam menyelesaikan pesanan Chef Mario.',
        progress: 2,
        target: 3,
        xpReward: 40,
        isCompleted: false,
        isClaimed: false,
      ),
      const DailyMissionModel(
        id: 'mis_3',
        title: 'Belajar 15 Menit Hari Ini',
        description: 'Pertahankan fokus belajarmu untuk menjaga streak harian.',
        progress: 15,
        target: 15,
        xpReward: 30,
        isCompleted: true,
        isClaimed: false,
      ),
    ];
  }

  void claimMission(String missionId) {
    state = [
      for (final mis in state)
        if (mis.id == missionId) mis.copyWith(isClaimed: true) else mis
    ];
  }

  void incrementGameQueries() {
    state = [
      for (final mis in state)
        if (mis.id == 'mis_2')
          mis.copyWith(
            progress: (mis.progress + 1).clamp(0, mis.target),
            isCompleted: (mis.progress + 1) >= mis.target,
          )
        else
          mis
    ];
  }
}

// Badges Provider
final badgesProvider = Provider<List<BadgeItem>>((ref) {
  return const [
    BadgeItem(
      id: 'bdg_1',
      title: 'First Query',
      description: 'Menjalankan query SQL pertama kali dengan sukses',
      iconEmoji: '⚡',
      isUnlocked: true,
      unlockedDate: '24 Okt 2026',
    ),
    BadgeItem(
      id: 'bdg_2',
      title: 'First Lesson',
      description: 'Menyelesaikan pelajaran teori dasar pertama',
      iconEmoji: '🎓',
      isUnlocked: true,
      unlockedDate: '24 Okt 2026',
    ),
    BadgeItem(
      id: 'bdg_3',
      title: 'Streak 3 Hari',
      description: 'Belajar 3 hari berturut-turut tanpa jeda',
      iconEmoji: '🔥',
      isUnlocked: true,
      unlockedDate: '26 Okt 2026',
    ),
    BadgeItem(
      id: 'bdg_4',
      title: 'SQL Master',
      description: 'Mencapai Level 10 SQL Master',
      iconEmoji: '👑',
      isUnlocked: false,
    ),
    BadgeItem(
      id: 'bdg_5',
      title: 'Bug Hunter',
      description: 'Menyelesaikan 10 challenge debug query',
      iconEmoji: '🐞',
      isUnlocked: false,
    ),
    BadgeItem(
      id: 'bdg_6',
      title: 'Speed King',
      description: 'Menyelesaikan tantangan SQL di bawah 60 detik',
      iconEmoji: '⏱️',
      isUnlocked: false,
    ),
  ];
});

// Leaderboard Provider
final leaderboardProvider = Provider<List<LeaderboardUser>>((ref) {
  return const [
    LeaderboardUser(rank: 1, username: 'dimas_postgres', level: 7, xp: 2450, rankChange: 2),
    LeaderboardUser(rank: 2, username: 'sarah_data', level: 6, xp: 1980, rankChange: 0),
    LeaderboardUser(rank: 3, username: 'budi_analyst', level: 6, xp: 1820, rankChange: -1),
    LeaderboardUser(rank: 4, username: 'alex_coder', level: 5, xp: 1450, rankChange: 1),
    LeaderboardUser(rank: 5, username: 'citra_sql', level: 5, xp: 1320, rankChange: 3),
    LeaderboardUser(rank: 6, username: 'rizky_dev', level: 4, xp: 1100, rankChange: -2),
    LeaderboardUser(rank: 7, username: 'maya_db', level: 4, xp: 990, rankChange: 0),
    LeaderboardUser(
      rank: 128,
      username: 'kevin_sql',
      level: 3,
      xp: 840,
      rankChange: 4,
      isCurrentUser: true,
    ),
  ];
});
