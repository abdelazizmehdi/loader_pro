import 'dart:math';
import 'package:flutter/material.dart';

class StarLoader extends StatefulWidget {
  final double size;
  final double stroke;
  final double speed;
  final double strokeLength;
  final Color color;
  final Color bgColor; // <-- added bgColor
  final Curve curve; // optional curve

  const StarLoader({
    Key? key,
    this.size = 50,
    this.stroke = 4,
    this.speed = 2,
    this.strokeLength = 0.25,
    this.color = Colors.deepPurpleAccent,
    this.bgColor = const Color(0x1A673AB7), // 10% opacity deepPurpleAccent
    this.curve = Curves.easeInOut,
  }) : super(key: key);

  @override
  State<StarLoader> createState() => _StarLoaderState();
}

class _StarLoaderState extends State<StarLoader>
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
            painter: _StarPainter(
              progress: _animation.value,
              stroke: widget.stroke,
              strokeLength: widget.strokeLength,
              color: widget.color,
              bgColor: widget.bgColor, // pass bgColor
            ),
          );
        },
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  final double progress;
  final double stroke;
  final double strokeLength;
  final Color color;
  final Color bgColor; // added

  _StarPainter({
    required this.progress,
    required this.stroke,
    required this.strokeLength,
    required this.color,
    required this.bgColor, // added
  });

  Path _buildStar(Size size) {
    final path = Path();
    final n = 5; // number of star points
    final r = size.width / 2;
    final center = Offset(r, r);

    for (int i = 0; i <= n; i++) {
      double angle = (i * 2 * pi / n) - pi / 2;
      double x = center.dx + r * cos(angle);
      double y = center.dy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildStar(size);

    final bgPaint = Paint()
      ..color = bgColor // use bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    canvas.drawPath(path, bgPaint);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final metric = path.computeMetrics().first;
    final length = metric.length;
    final visibleLength = strokeLength * length;

    final start = progress * length;
    final end = start + visibleLength;

    if (end <= length) {
      canvas.drawPath(metric.extractPath(start, end), paint);
    } else {
      canvas.drawPath(metric.extractPath(start, length), paint);
      canvas.drawPath(metric.extractPath(0, end - length), paint);
    }
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) => true;
}
