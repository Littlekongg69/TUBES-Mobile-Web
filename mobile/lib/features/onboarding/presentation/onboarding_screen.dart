import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/primary_action_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;

  // Selected values
  String _selectedLevel = 'Belum pernah';
  String _selectedDbExp = 'Tidak ada';
  String _selectedGoal = 'Tugas kuliah';
  int _selectedMinutes = 15;

  final List<String> _levels = ['Belum pernah', 'Dasar', 'Menengah', 'Mahir'];
  final List<String> _dbExperiences = [
    'Tidak ada',
    'Pernah memakai (MySQL, Postgres, Excel)',
    'Rutin bekerja dengan database',
  ];
  final List<String> _goals = ['Tugas kuliah', 'Karier / pekerjaan', 'Analisis data', 'Hobi'];
  final List<int> _durations = [5, 15, 30, 60];

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    } else {
      context.go('/home');
    }
  }

  void _skipOnboarding() {
    // PRD: Jika melewati onboarding, set path Beginner sebagai default
    context.go('/home');
  }

  String get _recommendedPath {
    if (_selectedLevel == 'Menengah' || _selectedLevel == 'Mahir') {
      return 'SQL Intermediate';
    }
    return 'SQL Beginner';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_currentStep < 4)
            TextButton(
              onPressed: _skipOnboarding,
              child: const Text('Lewati', style: TextStyle(color: AppColors.primary)),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Indicator (4 dots or line)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                child: LinearProgressIndicator(
                  value: (_currentStep + 1) / 5,
                  minHeight: 6,
                  backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: _buildStepContent(isDark),
              ),
              SizedBox(
                width: double.infinity,
                child: PrimaryActionButton(
                  label: _currentStep == 4 ? 'Mulai Petualangan SQL' : 'Lanjutkan',
                  onPressed: _nextStep,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildOptionStep(
          title: 'Seberapa jauh kamu memahami SQL? 📊',
          subtitle: 'Kami akan menyesuaikan materi sesuai pemahaman awalmu.',
          options: _levels,
          selected: _selectedLevel,
          onSelect: (val) => setState(() => _selectedLevel = val),
        );
      case 1:
        return _buildOptionStep(
          title: 'Bagaimana pengalamanmu dengan database? 💾',
          subtitle: 'Membantu menentukan titik awal pelajaran pertama kamu.',
          options: _dbExperiences,
          selected: _selectedDbExp,
          onSelect: (val) => setState(() => _selectedDbExp = val),
        );
      case 2:
        return _buildOptionStep(
          title: 'Apa tujuan utama belajarmu? 🎯',
          subtitle: 'Kami akan merekomendasikan tantangan dan kata motivasi yang relevan.',
          options: _goals,
          selected: _selectedGoal,
          onSelect: (val) => setState(() => _selectedGoal = val),
        );
      case 3:
        return _buildDurationStep(isDark);
      case 4:
      default:
        return _buildRecommendationStep(isDark);
    }
  }

  Widget _buildOptionStep({
    required String title,
    required String subtitle,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelect,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 28),
        ...options.map((option) {
          final isSelected = selected == option;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              onTap: () => onSelect(option),
              border: Border.all(
                color: isSelected ? AppColors.primary : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                width: isSelected ? 2 : 1,
              ),
              color: isSelected
                  ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF))
                  : null,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 22),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDurationStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Berapa lama kamu ingin belajar per hari? ⏱️',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Belajar sedikit setiap hari lebih efektif daripada belajar banyak dalam satu waktu.',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 32),
        ..._durations.map((mins) {
          final isSelected = _selectedMinutes == mins;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              onTap: () => setState(() => _selectedMinutes = mins),
              border: Border.all(
                color: isSelected ? AppColors.primary : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                width: isSelected ? 2 : 1,
              ),
              color: isSelected
                  ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF))
                  : null,
              child: Row(
                children: [
                  const Text('⚡', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Text(
                    '$mins Menit / hari',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    ),
                  ),
                  const Spacer(),
                  if (isSelected)
                    const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 22),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRecommendationStep(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Color(0xFFFEF3C7),
            shape: BoxShape.circle,
          ),
          child: const Center(child: Text('🎉', style: TextStyle(fontSize: 38))),
        ),
        const SizedBox(height: 20),
        Text(
          'Jalur Belajar Siap!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Berdasarkan preferensimu, kami merekomendasikan:',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 24),
        AppCard(
          padding: const EdgeInsets.all(AppDimensions.lg),
          border: Border.all(color: AppColors.primary, width: 2),
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    ),
                    child: const Text(
                      'Direkomendasikan',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _recommendedPath,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                '8 Modul • 18 Pelajaran • Hadiah 300 XP',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              Text(
                'Target harian: $_selectedMinutes menit/hari (Pengingat 19:00 WIB)',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
