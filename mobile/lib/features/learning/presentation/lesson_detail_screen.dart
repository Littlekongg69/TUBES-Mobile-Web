import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/providers/app_state_provider.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/primary_action_button.dart';

class LessonDetailScreen extends ConsumerStatefulWidget {
  final String moduleId;

  const LessonDetailScreen({super.key, required this.moduleId});

  @override
  ConsumerState<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends ConsumerState<LessonDetailScreen> {
  bool _isCompleted = false;
  bool _isRunningQuery = false;
  String? _queryOutput;

  void _runQuery(String query) async {
    setState(() => _isRunningQuery = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _isRunningQuery = false;
        _queryOutput = '''
| id | nama_produk       | harga   | stok |
|----|-------------------|---------|------|
| 1  | Laptop Gaming Pro | 15000000| 12   |
| 2  | Mechanical Keyboard| 850000 | 45   |
| 4  | Headset Wireless  | 750000  | 28   |
(3 baris dikembalikan dalam 12ms)
''';
      });
    }
  }

  void _completeLesson() {
    setState(() => _isCompleted = true);
    ref.read(userProvider.notifier).addXp(25);
    ref.read(modulesProvider.notifier).completeLesson(widget.moduleId, 'les_4');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        title: const Row(
          children: [
            Text('🎉 '),
            Text('Pelajaran Selesai!'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selamat! Kamu telah menyelesaikan materi ini.'),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.stars_rounded, color: AppColors.xpReward),
                SizedBox(width: 8),
                Text(
                  '+25 XP Berhasil Ditambahkan',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.xpReward),
                ),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
            },
            child: const Text('Lanjut Belajar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final modules = ref.watch(modulesProvider);
    final module = modules.firstWhere(
      (m) => m.id == widget.moduleId,
      orElse: () => modules.first,
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pelajaran SQL',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Module Title & Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Text(
                  'Modul 0${module.position} • Pelajaran Teori & Latihan',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                module.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.schedule_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    '${module.estimatedMinutes} Menit estimasi',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.stars_rounded, size: 16, color: AppColors.xpReward),
                  const SizedBox(width: 4),
                  const Text(
                    '+25 XP Reward',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.xpReward,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Theory Content Card
              AppCard(
                padding: const EdgeInsets.all(AppDimensions.base),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📖 Penjelasan Konsep',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Klausa WHERE digunakan untuk menyaring baris berdasarkan satu atau beberapa kondisi logika.\n\n'
                      'Hanya baris yang memenuhi kondisi bernilai TRUE yang akan disertakan dalam hasil akhir query. Anda dapat menggunakan operator perbandingan seperti =, !=, >, <, >=, <=, atau operator logika AND, OR, dan NOT.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Code Sandbox Preview
              Text(
                '💻 Contoh Kueri SQL Langsung',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.base),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B), // Dark code background
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'SQL Editor (Read-Only Demo)',
                          style: TextStyle(fontSize: 12, color: Colors.white60),
                        ),
                        ElevatedButton.icon(
                          onPressed: _isRunningQuery
                              ? null
                              : () => _runQuery('SELECT * FROM products WHERE harga > 500000;'),
                          icon: _isRunningQuery
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.play_arrow_rounded, size: 16),
                          label: const Text('Run Demo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'SELECT id, nama_produk, harga, stok\nFROM products\nWHERE harga > 500000\nORDER BY harga DESC;',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 13,
                        color: const Color(0xFF38BDF8),
                        height: 1.4,
                      ),
                    ),
                    if (_queryOutput != null) ...[
                      const Divider(color: Color(0xFF334155), height: 20),
                      Text(
                        _queryOutput!,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          color: const Color(0xFF4ADE80),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Complete Lesson Button
              SizedBox(
                width: double.infinity,
                child: PrimaryActionButton(
                  label: _isCompleted ? 'Pelajaran Telah Selesai ✓' : 'Selesaikan Pelajaran',
                  xpReward: _isCompleted ? null : 25,
                  onPressed: _isCompleted ? null : _completeLesson,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
