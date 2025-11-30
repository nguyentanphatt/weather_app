import 'package:flutter/material.dart';
import 'dart:math';

class WaterDropletAnimation extends StatefulWidget {
  final int dropletCount;
  const WaterDropletAnimation({super.key, this.dropletCount = 30});

  @override
  State<WaterDropletAnimation> createState() => _WaterDropletAnimationState();
}

class _WaterDropletAnimationState extends State<WaterDropletAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<WaterDroplet> _droplets;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_updateDroplets);

    _droplets = List.generate(
      widget.dropletCount,
      (_) => WaterDroplet.random(),
    );

    _controller.repeat();
  }

  void _updateDroplets() {
    setState(() {
      for (var i = 0; i < _droplets.length; i++) {
        final droplet = _droplets[i];

        if (droplet.state == DropletState.idle) {
          droplet.idleTime += 0.016; // ~60fps

          if (droplet.idleTime >= droplet.idleDuration) {
            droplet.state = DropletState.flowing;
          }
        }
        else if (droplet.state == DropletState.flowing) {
          droplet.progress += droplet.speed * 0.016;

          if (droplet.progress >= 1.0) {
            _droplets[i] = WaterDroplet.random();
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_updateDroplets);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: WaterDropletPainter(_droplets),
        size: MediaQuery.of(context).size,
      ),
    );
  }
}

enum DropletState {
  idle,
  flowing, 
}

class WaterDroplet {
  final double x;
  final double startY;
  final double size;
  final double speed;
  final double idleDuration;

  double progress;
  double idleTime;
  DropletState state;

  WaterDroplet({
    required this.x,
    required this.startY,
    required this.size,
    required this.speed,
    required this.idleDuration,
    this.progress = 0.0,
    this.idleTime = 0.0,
    this.state = DropletState.idle,
  });

  factory WaterDroplet.random() {
    final random = Random();
    return WaterDroplet(
      x: random.nextDouble(),
      startY: random.nextDouble() * 0.5,
      size: random.nextDouble() * 10 + 10,
      speed: random.nextDouble() * 0.2 + 0.05,
      idleDuration: random.nextDouble() * 2 + 1,
    );
  }
}

class WaterDropletPainter extends CustomPainter {
  final List<WaterDroplet> droplets;

  WaterDropletPainter(this.droplets);

  @override
  void paint(Canvas canvas, Size size) {
    for (var droplet in droplets) {
      final x = droplet.x * size.width;
      final startY = droplet.startY * size.height;

      if (droplet.state == DropletState.idle) {
        _drawIdleDroplet(canvas, Offset(x, startY), droplet.size);
      } else {
        final flowDistance = droplet.progress * (size.height - startY);
        _drawFlowingDroplet(
          canvas,
          Offset(x, startY),
          flowDistance,
          droplet.size,
        );
      }
    }
  }

  void _drawIdleDroplet(Canvas canvas, Offset position, double size) {
    final paint = Paint()
      ..color = Colors.blue.shade200.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = Colors.blue.shade100.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawOval(
      Rect.fromCenter(center: position, width: size * 1.2, height: size),
      glowPaint,
    );

    canvas.drawOval(
      Rect.fromCenter(center: position, width: size * 1.2, height: size),
      paint,
    );

    final highlightPaint = Paint()..color = Colors.white.withValues(alpha: 0.5);
    canvas.drawCircle(
      Offset(position.dx - size * 0.2, position.dy - size * 0.2),
      size * 0.25,
      highlightPaint,
    );
  }

  void _drawFlowingDroplet(
    Canvas canvas,
    Offset start,
    double distance,
    double size,
  ) {
    final paint = Paint()
      ..color = Colors.blue.shade200.withValues(alpha: 0.5)
      ..strokeWidth = size * 0.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(start.dx, start.dy);

    final segments = 10;
    for (var i = 1; i <= segments; i++) {
      final t = i / segments;
      final y = start.dy + distance * t;
      final wobble = sin(t * pi * 3) * size * 0.3;
      path.lineTo(start.dx + wobble, y);
    }

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.blue.shade200.withValues(alpha: 0.2),
        Colors.blue.shade300.withValues(alpha: 0.6),
      ],
    );

    paint.shader = gradient.createShader(
      Rect.fromPoints(start, Offset(start.dx, start.dy + distance)),
    );

    canvas.drawPath(path, paint);

    final dropEnd = Offset(
      start.dx + sin(distance / 50) * size * 0.3,
      start.dy + distance,
    );

    final dropPaint = Paint()
      ..color = Colors.blue.shade300.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    final dropPath = Path();
    dropPath.moveTo(dropEnd.dx, dropEnd.dy);
    dropPath.quadraticBezierTo(
      dropEnd.dx - size * 0.4,
      dropEnd.dy - size * 0.5,
      dropEnd.dx,
      dropEnd.dy - size,
    );
    dropPath.quadraticBezierTo(
      dropEnd.dx + size * 0.4,
      dropEnd.dy - size * 0.5,
      dropEnd.dx,
      dropEnd.dy,
    );

    canvas.drawPath(dropPath, dropPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
