import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final Border? border;
  final double? borderRadius;
  final List<BoxShadow>? shadows;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.color,
    this.border,
    this.borderRadius,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = color ?? (isDark ? AppColors.darkCardSurface : AppColors.lightCardSurface);
    final borderColor = border ?? Border.all(
      color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
      width: 1,
    );
    final radius = BorderRadius.circular(borderRadius ?? AppDimensions.radiusLg);

    Widget content = Container(
      padding: padding ?? const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: radius,
        border: borderColor,
        boxShadow: shadows ?? (isDark ? null : AppDimensions.softCardShadow),
      ),
      child: child,
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: content,
        ),
      );
    }

    return content;
  }
}
