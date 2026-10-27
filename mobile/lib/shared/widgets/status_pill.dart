import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../models/learning_models.dart';

class StatusPill extends StatelessWidget {
  final ModuleStatus status;

  const StatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;
    IconData icon;

    switch (status) {
      case ModuleStatus.completed:
        bg = AppColors.successContainer;
        fg = AppColors.success;
        label = 'Selesai';
        icon = Icons.check_circle_rounded;
        break;
      case ModuleStatus.inProgress:
        bg = AppColors.primaryContainer;
        fg = AppColors.primary;
        label = 'Sedang Berjalan';
        icon = Icons.play_circle_fill_rounded;
        break;
      case ModuleStatus.locked:
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF64748B);
        label = 'Terkunci';
        icon = Icons.lock_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
