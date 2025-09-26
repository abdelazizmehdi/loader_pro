import 'dart:math';
import 'package:flutter/material.dart';

class TrefoilLoader extends StatefulWidget {
  final double size;
  final double stroke;
  final double strokeLength;
  final Color color;
  final Color bgColor; // new bg color parameter
  final double speed;
  final Curve curve; // new curve parameter

  const TrefoilLoader({
    Key? key,
    this.size = 100,
    this.stroke = 6,
    this.strokeLength = 0.25,
    this.color = Colors.deepPurpleAccent,
    this.bgColor = const Color(0x26363AB7), // ~15% opacity
    this.speed = 2.5,
    this.curve = Curves.easeInOut,
  }) : super(key: key);

  @override
  State<TrefoilLoader> createState() => _TrefoilLoaderState();
}

class _TrefoilLoaderState extends State<TrefoilLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.speed * 1000).round()),
    )..repeat();

    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
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
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (_, __) {
          return CustomPaint(
            painter: _TrefoilPainter(
              progress: _animation.value,
              stroke: widget.stroke,
              strokeLength: widget.strokeLength,
              color: widget.color,
              bgColor: widget.bgColor,
            ),
          );
        },
      ),
    );
  }
}

class _TrefoilPainter extends CustomPainter {
  final double progress;
  final double stroke;
  final double strokeLength;
  final Color color;
  final Color bgColor;

  _TrefoilPainter({
    required this.progress,
    required this.stroke,
    required this.strokeLength,
    required this.color,
    required this.bgColor,
  });

  Path _buildTrefoilPath(Size size) {
    final w = size.width / 2;
    final h = size.height / 2;

    final path = Path();
    const int steps = 500;
    for (int i = 0; i <= steps; i++) {
      final t = 2 * pi * i / steps;
      final x = (sin(t) + 2 * sin(2 * t)) * 0.25 * w;
      final y = (cos(t) - 2 * cos(2 * t)) * 0.25 * h;

      if (i == 0) {
        path.moveTo(w + x, h + y);
      } else {
        path.lineTo(w + x, h + y);
      }
    }
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildTrefoilPath(size);

    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    canvas.drawPath(path, bgPaint);

    final carPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final metrics = path.computeMetrics().first;
    final length = metrics.length;
    final visibleLength = strokeLength * length;

    final start = progress * length;
    final end = start + visibleLength;

    if (end <= length) {
      canvas.drawPath(metrics.extractPath(start, end), carPaint);
    } else {
      canvas.drawPath(metrics.extractPath(start, length), carPaint);
      canvas.drawPath(metrics.extractPath(0, end - length), carPaint);
    }
  }

  @override
  bool shouldRepaint(_TrefoilPainter oldDelegate) => true;
}
