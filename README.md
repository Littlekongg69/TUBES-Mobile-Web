# SQLQuest — Platform Belajar SQL Gamifikasi (Mobile App - Milestone 40%)

Aplikasi mobile Flutter untuk **SQLQuest** (Platform Belajar SQL Gamifikasi) yang dirancang berdasarkan **Dokumen PRD (Product Requirements Document)** untuk Android (API 26+) dengan Clean Architecture, Riverpod, dan GoRouter.

---

## 📊 Cakupan Pengerjaan Milestone 40%

Sesuai arahan PRD untuk deliverable awal (tahap 40% MVP):

| Komponen / Fitur | Status (40%) | Catatan Implementasi |
| :--- | :---: | :--- |
| **Arsitektur & Setup (Clean Architecture)** | ✅ Selesai | 3 Lapis: `core/`, `features/`, `shared/` |
| **Design Tokens & Theme** | ✅ Selesai | Light & Dark Mode, Palet Warna PRD (#2563EB, #F59E0B, #16A34A, dll.), Font Inter & JetBrains Mono |
| **Alur Autentikasi (Splash & Auth)** | ✅ Selesai | Splash Screen (Animasi + auto-routing), Login (Email/Password & simulasi Google Auth), Register (validasi FR-AUTH-01), Lupa Password |
| **Alur Onboarding (FR-AUTH & FR-LRN)** | ✅ Selesai | 4 Pertanyaan Onboarding (Tingkat kemahiran, Pengalaman DB, Tujuan belajar, Waktu belajar harian) & rekomendasi learning path |
| **Navigasi Utama (Persistent Shell)** | ✅ Selesai | Bottom Navigation 4 Tab (`IndexedStack`): Beranda, Belajar, Game, Profil |
| **Layar Beranda (Home Screen)** | ✅ Selesai | Kartu Sapaan, XP Bar dinamis, Streak Chip (🔥), Tantangan Harian, Minggu Ini (7 hari kalender), Statistik Cepat (Akurasi & Misi), Lanjutkan Belajar, Peringkat Global |
| **Layar Belajar (Learn Screen)** | ✅ Selesai | Pencarian materi real-time, filter (Semua, Sedang Berjalan, Selesai), daftar modul berstatus (Selesai, Aktif, Terkunci dengan Bottom Sheet prasyarat) |
| **Layar Detail Pelajaran (Lesson Detail)** | ✅ Selesai | Teori konsep SQL, Code Sandbox simulator (Run Demo), tombol Selesaikan Pelajaran (+25 XP) |
| **Layar Game (SQL Cooking Quest - Mode Blok)** | ✅ Selesai | Mode Blok interaktif: Indikator Hati (❤️❤️❤️❤️❤️), Kartu Cerita & Target, Tabel Skema Data (scroll horizontal), Area Perakitan Blok & Pilihan Blok SQL (termasuk pengecoh), Jalankan Query (+40 XP), Feedback Berhasil/Salah, Petunjuk Soal (-4 XP) |
| **Layar Profil & Pengaturan** | ✅ Selesai | Identitas pengguna, XP & Level Progres, Grid Statistik 2x2, Carousel Badge (Unopened vs Locked), Switch Mode Gelap, Edit Profil |
| **Layar Peringkat (Leaderboard)** | ✅ Selesai | Tab Global / Mingguan / Bulanan, Podium Top 3 (Emas, Perak, Perunggu), daftar user, kartu melayang sticky peringkat pengguna (#128) |
| **Layar Misi Harian (Daily Missions)** | ✅ Selesai | 3 Misi harian interaktif dengan tombol "Klaim Hadiah (+XP)" yang memperbarui total XP pengguna secara reaktif |
| **State Management (Riverpod)** | ✅ Selesai | State reaktif terpusat untuk User, Modul, Misi, Leaderboard, dan Theme Mode |
| **Pengujian Otomatis (Tests)** | ✅ Selesai | 7 automated unit & widget tests (100% lulus) menguji formula level $50 \times L \times (L - 1)$, XP, dan validasi kueri blok |

---

## 🛠️ Struktur Proyek

```
mobile/
├── android/app/build.gradle.kts    # Min SDK 26 (Android 8.0+)
├── lib/
│   ├── main.dart                   # ProviderScope & MaterialApp.router
│   ├── core/
│   │   ├── constants/              # app_colors.dart, app_dimensions.dart
│   │   ├── providers/              # app_state_provider.dart (Riverpod Notifiers)
│   │   ├── routing/                # app_router.dart (GoRouter)
│   │   └── theme/                  # app_theme.dart, theme_provider.dart
│   ├── shared/
│   │   ├── models/                 # user_model, learning_models, challenge_model, mission_model, leaderboard_model
│   │   └── widgets/                # AppCard, XpProgressBar, StreakChip, StatTile, WeekStreakRow, ModuleCard, StatusPill, MissionBanner, HeartsIndicator, TableDataCard, SqlBlockChip, PrimaryActionButton, BadgeTile, AppBottomNav
│   └── features/
│       ├── auth/presentation/      # splash_screen, login_screen, register_screen, forgot_password_screen
│       ├── onboarding/presentation/# onboarding_screen
│       ├── home/presentation/      # home_screen
│       ├── learning/presentation/  # learning_screen, lesson_detail_screen
│       ├── sql_game/presentation/  # sql_game_screen
│       ├── profile/presentation/   # profile_screen
│       ├── leaderboard/presentation/# leaderboard_screen
│       ├── mission/presentation/   # daily_missions_screen
│       └── main_shell.dart         # 4-tab persistent shell
└── test/
    ├── gamification_test.dart      # Formula PRD 50*L*(L-1), XP level-up & missions
    ├── sql_game_test.dart          # Validasi blok SQL & pengecoh
    └── widget_test.dart            # Smoke test & alur transisi
```

---

## 🚀 Cara Menjalankan

### 1. Masuk ke direktori mobile:
```bash
cd mobile
```

### 2. Jalankan Pengujian:
```bash
flutter test
```

### 3. Jalankan Aplikasi pada Android Emulator / Device:
```bash
flutter run
```

### 4. Jalankan Aplikasi pada Web / Desktop (Opsional):
```bash
flutter run -d chrome
```
