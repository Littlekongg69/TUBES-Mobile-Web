import 'package:flutter/material.dart';

class HeartsIndicator extends StatelessWidget {
  final int currentHearts;
  final int maxHearts;

  const HeartsIndicator({
    super.key,
    required this.currentHearts,
    this.maxHearts = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxHearts, (index) {
        final isFilled = index < currentHearts;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: isFilled ? 1.0 : 0.85,
            child: Text(
              isFilled ? '❤️' : '🖤',
              style: TextStyle(
                fontSize: 16,
                color: isFilled ? Colors.red : Colors.grey,
              ),
            ),
          ),
        );
      }),
    );
  }
}
