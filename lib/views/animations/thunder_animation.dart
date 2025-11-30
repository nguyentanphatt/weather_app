import 'package:flutter/material.dart';
import 'dart:math';

class ThunderStormAnimation extends StatefulWidget {
  final int lightningFrequency;
  final int minLightnings; 
  final int maxLightnings; 

  const ThunderStormAnimation({
    super.key,
    this.lightningFrequency = 4,
    this.minLightnings = 1,
    this.maxLightnings = 3,
  });

  @override
  State<ThunderStormAnimation> createState() => _ThunderStormAnimationState();
}

class _ThunderStormAnimationState extends State<ThunderStormAnimation> {
  final List<Lightning> _activeLightnings = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startThunderStorm();
  }

  void _startThunderStorm() {
    Future.delayed(Duration.zero, () {
      _createLightningBurst();
    });
  }

  void _createLightningBurst() {
    if (!mounted) return;

    final count =
        _random.nextInt(widget.maxLightnings - widget.minLightnings + 1) +
        widget.minLightnings;

    setState(() {
      for (var i = 0; i < count; i++) {
        _activeLightnings.add(Lightning.random());
      }
    });

    final duration = _random.nextInt(500) + 1000; 
    Future.delayed(Duration(milliseconds: duration), () {
      if (mounted) {
        setState(() {
          _activeLightnings.clear();
        });
      }
    });

    final nextDelay =
        _random.nextInt(2000) + (widget.lightningFrequency * 1000);
    Future.delayed(Duration(milliseconds: nextDelay), () {
      _createLightningBurst();
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: ThunderStormPainter(_activeLightnings),
        size: MediaQuery.of(context).size,
      ),
    );
  }
}

class Lightning {
  final double startX;
  final List<Offset> points;
  final double brightness;

  Lightning({
    required this.startX,
    required this.points,
    required this.brightness,
  });

  factory Lightning.random() {
    final random = Random();
    final startX = random.nextDouble();
    final brightness = random.nextDouble() * 0.5 + 0.5; 

    final points = <Offset>[];
    double currentX = startX;
    double currentY = 0.0;

    final segments = random.nextInt(8) + 4;

    for (var i = 0; i < segments; i++) {
      points.add(Offset(currentX, currentY));

      currentY += random.nextDouble() * 0.08 + 0.05;

      currentX += (random.nextDouble() - 0.5) * 0.1;

      // Giới hạn không ra ngoài màn hình
      currentX = currentX.clamp(0.0, 2.0);

      if (currentY > 1.0) break;
    }

    points.add(Offset(currentX, min(currentY, 1.0)));

    return Lightning(startX: startX, points: points, brightness: brightness);
  }
}

class ThunderStormPainter extends CustomPainter {
  final List<Lightning> lightnings;

  ThunderStormPainter(this.lightnings);

  @override
  void paint(Canvas canvas, Size size) {
    for (var lightning in lightnings) {
      _drawLightning(canvas, size, lightning);
    }
  }

  void _drawLightning(Canvas canvas, Size size, Lightning lightning) {
    final pixelPoints = lightning.points
        .map((p) => Offset(p.dx * size.width, p.dy * size.height))
        .toList();

    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3 * lightning.brightness)
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    final glowPath = Path();
    glowPath.moveTo(pixelPoints[0].dx, pixelPoints[0].dy);
    for (var i = 1; i < pixelPoints.length; i++) {
      glowPath.lineTo(pixelPoints[i].dx, pixelPoints[i].dy);
    }
    canvas.drawPath(glowPath, glowPaint);

    final mainPaint = Paint()
      ..color = Color.lerp(
        Colors.cyan.shade200,
        Colors.white,
        lightning.brightness,
      )!
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final mainPath = Path();
    mainPath.moveTo(pixelPoints[0].dx, pixelPoints[0].dy);
    for (var i = 1; i < pixelPoints.length; i++) {
      mainPath.lineTo(pixelPoints[i].dx, pixelPoints[i].dy);
    }
    canvas.drawPath(mainPath, mainPaint);

    final corePaint = Paint()
      ..color = Colors.yellow[50]!
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final corePath = Path();
    corePath.moveTo(pixelPoints[0].dx, pixelPoints[0].dy);
    for (var i = 1; i < pixelPoints.length; i++) {
      corePath.lineTo(pixelPoints[i].dx, pixelPoints[i].dy);
    }
    canvas.drawPath(corePath, corePaint);
  }

  @override
  bool shouldRepaint(ThunderStormPainter oldDelegate) {
    return oldDelegate.lightnings != lightnings;
  }
}
