import 'package:flutter/material.dart';
import 'dart:math';

class RainAnimation extends StatefulWidget {
  final int rainDropCount;
  const RainAnimation({super.key, this.rainDropCount = 100});

  @override
  State<RainAnimation> createState() => _RainAnimationState();
}

class _RainAnimationState extends State<RainAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<RainDrop> _rainDrops;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _rainDrops = List.generate(widget.rainDropCount, (_) => _createRainDrop());
  }

  RainDrop _createRainDrop() {
    return RainDrop(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      length: _random.nextDouble() * 15 + 10,
      speed: _random.nextDouble() * 0.5 + 0.8,
      thickness: _random.nextDouble() * 1.5 + 1,
      color: Colors.blue.withValues(alpha: _random.nextDouble() * 0.3 + 0.3),
    );
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
            size: MediaQuery.of(context).size,
            painter: RainPainter(_rainDrops),
          );
        },
      ),
    );
  }
}

class RainDrop {
  double x;
  double y;
  final double length;
  final double speed;
  final double thickness;
  final Color color;

  RainDrop({
    required this.x,
    required this.y,
    required this.length,
    required this.speed,
    required this.thickness,
    required this.color,
  });
}

class RainPainter extends CustomPainter {
  final List<RainDrop> rainDrops;
  final Random _random = Random();

  RainPainter(this.rainDrops);

  @override
  void paint(Canvas canvas, Size size) {
    for (var drop in rainDrops) {
      drop.y += drop.speed * 0.01;
      if (drop.y > 1) {
        drop.y = 0;
        drop.x = _random.nextDouble();
      }

      double yPos = drop.y * size.height;
      double xPos = drop.x * size.width;

      final paint = Paint()
        ..strokeWidth = drop.thickness
        ..strokeCap = StrokeCap.round;

      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [drop.color.withValues(alpha: 0), drop.color],
      );

      final rect = Rect.fromPoints(
        Offset(xPos, yPos),
        Offset(xPos, yPos + drop.length),
      );
      paint.shader = gradient.createShader(rect);

      canvas.drawLine(
        Offset(xPos, yPos),
        Offset(xPos, yPos + drop.length),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
