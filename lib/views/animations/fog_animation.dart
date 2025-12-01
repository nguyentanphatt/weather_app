import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' as ui;

class FogAnimation extends StatefulWidget {
  final int fogCount;
  const FogAnimation({super.key, this.fogCount = 4});

  @override
  State<FogAnimation> createState() => _FogAnimationState();
}

class _FogAnimationState extends State<FogAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late List<FogPatch> _fogPatches;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    // Fade + Scale controller
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _fogPatches = List.generate(widget.fogCount, (_) => FogPatch.random());

    // Delay rồi fade in + scale
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return CustomPaint(
                painter: FogPainter(_fogPatches, _controller.value),
                size: MediaQuery.of(context).size,
                willChange: true, // Hint for better performance
              );
            },
          ),
        ),
      ),
    );
  }
}

class FogPatch {
  final double startX;
  final double y;
  final double width;
  final double height;
  final double speed;
  final double opacity;

  FogPatch({
    required this.startX,
    required this.y,
    required this.width,
    required this.height,
    required this.speed,
    required this.opacity,
  });

  factory FogPatch.random() {
    final random = Random();
    return FogPatch(
      startX: random.nextDouble(),
      y: random.nextDouble() * 0.6, // Top 60% of screen
      width: random.nextDouble() * 300 + 400, // 400-700
      height: random.nextDouble() * 200 + 250, // 250-450
      speed: random.nextDouble() * 0.015 + 0.005, // 0.005-0.02
      opacity: random.nextDouble() * 0.15 + 0.15, // 0.15-0.3
    );
  }
}

class FogPainter extends CustomPainter {
  final List<FogPatch> fogPatches;
  final double progress;

  FogPainter(this.fogPatches, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final hour = DateTime.now().hour;
    final baseColor = hour > 18 || hour < 6
        ? Colors.grey.shade600
        : Colors.grey.shade300;

    for (var fog in fogPatches) {
      // Calculate position with wrapping
      double x = ((fog.startX + progress * fog.speed) % 1.0) * size.width;
      double y = fog.y * size.height;

      _drawFog(
        canvas,
        size,
        Offset(x, y),
        fog.width,
        fog.height,
        baseColor.withValues(alpha: fog.opacity),
      );
    }
  }

  void _drawFog(
    Canvas canvas,
    Size size,
    Offset center,
    double width,
    double height,
    Color color,
  ) {
    // Simple radial gradient - optimized
    final rect = Rect.fromCenter(center: center, width: width, height: height);

    final gradient = ui.Gradient.radial(
      center,
      width * 0.5,
      [
        color,
        color.withValues(alpha: color.a * 0.5),
        color.withValues(alpha: 0),
      ],
      [0.0, 0.6, 1.0],
    );

    final paint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);

    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(FogPainter oldDelegate) {
    // Only repaint when actually needed
    return oldDelegate.progress != progress;
  }
}
