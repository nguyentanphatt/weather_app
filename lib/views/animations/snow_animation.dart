import 'package:flutter/material.dart';
import 'dart:math';

class SnowAnimation extends StatefulWidget {
  final int snowFlakeCount;
  const SnowAnimation({super.key, this.snowFlakeCount = 20});

  @override
  State<SnowAnimation> createState() => _SnowAnimationState();
}

class _SnowAnimationState extends State<SnowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<SnowFlake> _snowFlakes;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _snowFlakes = List.generate(
      widget.snowFlakeCount,
      (_) => _createSnowFlake(),
    );
  }

  SnowFlake _createSnowFlake() {
    return SnowFlake(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: _random.nextDouble() * 4 + 2,
      speed: _random.nextDouble() * 0.2 + 0.1,
      swingAmplitude: _random.nextDouble() * 0.02 + 0.01,
      swingFrequency: _random.nextDouble() * 3 + 2,
      color: Colors.white.withValues(alpha: _random.nextDouble() * 0.5 + 0.5),
      yOffset: _random.nextDouble(),
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
          final progress = _controller.value;
          return CustomPaint(
            size: MediaQuery.of(context).size,
            painter: SnowPainter(_snowFlakes, progress),
          );
        },
      ),
    );
  }
}

class SnowFlake {
  double x;
  double y; 
  final double size;
  final double speed;
  final double swingAmplitude;
  final double swingFrequency;
  final Color color;
  double yOffset;

  SnowFlake({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.swingAmplitude,
    required this.swingFrequency,
    required this.color,
    required this.yOffset,
  });
}

class SnowPainter extends CustomPainter {
  final List<SnowFlake> snowFlakes;
  final double progress;

  SnowPainter(this.snowFlakes, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (var flake in snowFlakes) {
      flake.y += flake.speed * 0.005; 
      if (flake.y > 1) {
        flake.y = 0; 
        flake.x = Random().nextDouble();
      }

      double yPos = flake.y * size.height;

      double swing =
          sin((flake.y + flake.yOffset) * flake.swingFrequency * 2 * pi) *
          flake.swingAmplitude *
          size.width;
      double xPos = flake.x * size.width + swing;

      _drawSnowFlake(canvas, Offset(xPos, yPos), flake);
    }
  }

  void _drawSnowFlake(Canvas canvas, Offset center, SnowFlake flake) {
    final paint = Paint()
      ..color = flake.color
      ..style = PaintingStyle.fill;

    // Glow nhẹ
    final glowPaint = Paint()
      ..color = flake.color.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(center, flake.size + 2, glowPaint);

    // Vẽ bông tuyết chính
    canvas.drawCircle(center, flake.size, paint);

    // Vẽ hoa tuyết nhỏ
    if (flake.size > 4) {
      final detailPaint = Paint()
        ..color = flake.color.withOpacity(0.8)
        ..strokeWidth = 0.5
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < 6; i++) {
        double angle = i * pi / 3;
        double endX = center.dx + cos(angle) * flake.size;
        double endY = center.dy + sin(angle) * flake.size;
        canvas.drawLine(center, Offset(endX, endY), detailPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
