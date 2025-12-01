import 'package:flutter/material.dart';
import 'dart:math';

class WindChime extends StatefulWidget {
  final double windSpeed;
  final double size;

  const WindChime({super.key, required this.windSpeed, this.size = 120});

  @override
  State<WindChime> createState() => _WindChimeState();
}

class _WindChimeState extends State<WindChime>
  with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _swingAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    final isWindy = widget.windSpeed > 2.0;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: isWindy ? (1200 - (widget.windSpeed * 50).toInt()) : 2000,
      ),
    );

    if (isWindy) {
      final swingAmount = min(widget.windSpeed * 0.04, 0.25);
      _swingAnimation = Tween<double>(
        begin: -swingAmount,
        end: swingAmount,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.repeat(reverse: true);
    } else {
      _swingAnimation = Tween<double>(begin: 0, end: 0).animate(_controller);
    }
  }

  @override
  void didUpdateWidget(WindChime oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.windSpeed != widget.windSpeed) {
      _controller.dispose();
      _setupAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size * 2.5,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [

          Positioned(
            top: 0,
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: GlassBallPainter(),
            ),
          ),

          Positioned(
            top: widget.size * 0.9,
            child: AnimatedBuilder(
              animation: _swingAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _swingAnimation.value,
                  alignment: Alignment.topCenter,
                  child: child,
                );
              },
              child: CustomPaint(
                size: Size(widget.size * 0.35, widget.size * 1.3),
                painter: TanzakuPainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GlassBallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(
      Offset(center.dx + 3, center.dy + 3),
      radius,
      shadowPaint,
    );

    final ringPaint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(Offset(center.dx, 5), 8, ringPaint);

    final glassPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.4),
          Colors.blue.shade100.withValues(alpha: 0.3),
          Colors.blue.shade200.withValues(alpha: 0.4),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, glassPaint);

    final borderPaint = Paint()
      ..color = Colors.blue.shade300.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, borderPaint);

    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.3),
      radius * 0.25,
      highlightPaint,
    );

    final clapperPaint = Paint()..color = Colors.grey.shade700;
    canvas.drawCircle(
      Offset(center.dx, center.dy + radius * 0.6),
      6,
      clapperPaint,
    );

    final bottomStringPaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(center.dx, center.dy + radius),
      Offset(center.dx, size.height),
      bottomStringPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TanzakuPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    final paperPath = Path()
      ..moveTo(size.width * 0.5, 0)
      ..lineTo(size.width, size.height * 0.15)
      ..lineTo(size.width, size.height * 0.85)
      ..lineTo(0, size.height * 0.85)
      ..lineTo(0, size.height * 0.15)
      ..close();

    final paperPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white, Colors.grey.shade50, Colors.grey.shade100],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(paperPath, paperPaint);

    final borderPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(paperPath, borderPaint);

    final flowerPaint = Paint()..color = Colors.red.shade300.withValues(alpha: 0.6);

    for (var i = 0; i < 3; i++) {
      final y = size.height * 0.25 + (i * size.height * 0.15);
      _drawSmallFlower(canvas, Offset(size.width * 0.3, y), flowerPaint);
      _drawSmallFlower(canvas, Offset(size.width * 0.7, y), flowerPaint);
    }

    final leafPaint = Paint()..color = Colors.green.shade300.withValues(alpha: 0.5);
    for (var i = 0; i < 2; i++) {
      final y = size.height * 0.35 + (i * size.height * 0.2);
      _drawSmallLeaf(canvas, Offset(size.width * 0.5, y), leafPaint);
    }
  }

  void _drawSmallFlower(Canvas canvas, Offset center, Paint paint) {
    for (var i = 0; i < 5; i++) {
      final angle = (i * 2 * pi / 5) - pi / 2;
      final x = center.dx + cos(angle) * 4;
      final y = center.dy + sin(angle) * 4;
      canvas.drawCircle(Offset(x, y), 3, paint);
    }

    final centerPaint = Paint()..color = Colors.amber.shade200;
    canvas.drawCircle(center, 2, centerPaint);
  }

  void _drawSmallLeaf(Canvas canvas, Offset center, Paint paint) {
    final leafPath = Path()
      ..moveTo(center.dx, center.dy)
      ..quadraticBezierTo(
        center.dx - 6,
        center.dy + 4,
        center.dx - 3,
        center.dy + 8,
      )
      ..quadraticBezierTo(center.dx, center.dy + 6, center.dx, center.dy);
    canvas.drawPath(leafPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
