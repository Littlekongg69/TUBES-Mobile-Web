import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../models/challenge_model.dart';

class SqlBlockChip extends StatelessWidget {
  final SqlBlock block;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isSlotBlock;

  const SqlBlockChip({
    super.key,
    required this.block,
    this.onTap,
    this.isSelected = false,
    this.isSlotBlock = false,
  });

  Color _getBlockColor(BlockType type) {
    switch (type) {
      case BlockType.keyword:
        return AppColors.blockKeyword;
      case BlockType.table:
        return AppColors.blockTable;
      case BlockType.column:
        return AppColors.blockColumn;
      case BlockType.condition:
        return AppColors.blockCondition;
      case BlockType.clause:
        return AppColors.primaryDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getBlockColor(block.type);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isSlotBlock ? 1.0 : 0.12),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color: color,
              width: 1.5,
            ),
            boxShadow: isSlotBlock
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                block.label,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSlotBlock ? Colors.white : color,
                ),
              ),
              if (isSlotBlock) ...[
                const SizedBox(width: 4),
                const Icon(Icons.close_rounded, size: 14, color: Colors.white70),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
