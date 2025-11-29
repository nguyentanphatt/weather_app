import 'package:flutter/material.dart';

class GlassCardWidget extends StatelessWidget {
  const GlassCardWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: child,
    );
  }
}
