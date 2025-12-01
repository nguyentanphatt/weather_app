import 'package:flutter/material.dart';
import 'dart:math';

class CloudAnimation extends StatefulWidget {
  final int cloudCount;
  const CloudAnimation({super.key, this.cloudCount = 5});

  @override
  State<CloudAnimation> createState() => _CloudAnimationState();
}

class _CloudAnimationState extends State<CloudAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late List<Cloud> _clouds;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    // Fade controller - reversible để fade in/out
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _clouds = List.generate(widget.cloudCount, (_) => Cloud.random());

    // Delay rồi fade in
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
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, _) {
            return CustomPaint(
              painter: CloudPainter(_clouds, _controller.value),
              size: MediaQuery.of(context).size,
            );
          },
        ),
      ),
    );
  }
}

class Cloud {
  final Offset position;
  final double width;
  final double height;
  final Color color;
  final double opacity;
  final double speed;

  Cloud({
    required this.position,
    required this.width,
    required this.height,
    required this.color,
    required this.opacity,
    required this.speed,
  });

  factory Cloud.random() {
    final random = Random();
    final hour = DateTime.now().hour;
    return Cloud(
      position: Offset(random.nextDouble(), random.nextDouble() * 0.15),
      width: random.nextDouble() * 100 + 150,
      height: random.nextDouble() * 100 + 100,
      color: hour > 18
          ? (random.nextBool() ? Colors.grey.shade500 : Colors.grey.shade600)
          : (random.nextBool() ? Colors.grey.shade300 : Colors.grey.shade400),
      opacity: random.nextDouble() * 0.3 + 0.5,
      speed: random.nextDouble() * 0.05 + 0.01,
    );
  }
}

class CloudPainter extends CustomPainter {
  final List<Cloud> clouds;
  final double progress;

  CloudPainter(this.clouds, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (var cloud in clouds) {
      double x =
          ((cloud.position.dx + progress * cloud.speed) % 1.0) * size.width;
      double y = cloud.position.dy * size.height;

      _drawCloud(
        canvas,
        Offset(x, y),
        cloud.width,
        cloud.height,
        cloud.color.withValues(alpha: cloud.opacity),
      );
    }
  }

  void _drawCloud(
    Canvas canvas,
    Offset center,
    double width,
    double height,
    Color color,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawCircle(center, width * 0.5, paint);

    canvas.drawCircle(
      Offset(center.dx - width * 0.2, center.dy + height * 0.2),
      width * 0.2,
      paint,
    );

    canvas.drawCircle(
      Offset(center.dx + width * 0.3, center.dy + height * 0.3),
      width * 0.3,
      paint,
    );

    canvas.drawCircle(
      Offset(center.dx - width * 0.1, center.dy - height * 0.1),
      width * 0.2,
      paint,
    );

    canvas.drawCircle(
      Offset(center.dx + width * 0.4, center.dy - height * 0.1),
      width * 0.3,
      paint,
    );

    canvas.drawCircle(
      Offset(center.dx, center.dy + height * 0.15),
      width * 0.22,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
