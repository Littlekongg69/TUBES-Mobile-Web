import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class StreakChip extends StatelessWidget {
  final int streakDays;
  final bool isCompact;

  const StreakChip({
    super.key,
    required this.streakDays,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED), // Warm amber background
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: const Color(0xFFFDBA74), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            isCompact ? '$streakDays' : '$streakDays Hari',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.streakFire,
            ),
          ),
        ],
      ),
    );
  }
}
