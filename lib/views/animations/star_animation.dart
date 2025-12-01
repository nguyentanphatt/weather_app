import 'dart:math';
import 'package:flutter/material.dart';

class StarBlinkingAnimation extends StatefulWidget {
  final int starCount;
  const StarBlinkingAnimation({super.key, this.starCount = 50});

  @override
  State<StarBlinkingAnimation> createState() => _StarBlinkingAnimationState();
}

class _StarBlinkingAnimationState extends State<StarBlinkingAnimation>
  with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Star> _stars;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _stars = List.generate(widget.starCount, (_) => Star.random());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, _) {
          return CustomPaint(
            painter: StarPainter(_stars, _controller.value),
            size: MediaQuery.of(context).size,
          );
        },
      ),
    );
  }
}

class Star {
  final Offset position;
  final double size;
  final double flickerSpeed;

  Star({
    required this.position,
    required this.size,
    required this.flickerSpeed,
  });

  factory Star.random() {
    final random = Random();
    return Star(
      position: Offset(random.nextDouble(), random.nextDouble()),
      size: random.nextDouble() * 2 + 1,
      flickerSpeed: random.nextDouble() * 2,
    );
  }
}

class StarPainter extends CustomPainter {
  final List<Star> stars;
  final double progress;

  StarPainter(this.stars, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (var star in stars) {
      final x = star.position.dx * size.width;
      final y = star.position.dy * size.height;

      final opacity = (sin(progress * pi * star.flickerSpeed) + 1) / 2;

      paint.color = Colors.white.withValues(alpha: opacity);

      canvas.drawCircle(Offset(x, y), star.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
