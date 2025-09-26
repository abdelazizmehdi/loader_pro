import 'dart:math';
import 'package:flutter/material.dart';

class SquareLoader extends StatefulWidget {
  final double size;
  final double stroke;
  final double strokeLength;
  final Color bgColor; // changed from bgOpacity
  final double speed;
  final Color color;
  final Curve curve; // new: animation curve

  const SquareLoader({
    Key? key,
    this.size = 35,
    this.stroke = 5,
    this.strokeLength = 0.25,
    this.bgColor = const Color(0x1A673AB7),
    this.speed = 1.2,
    this.color = Colors.deepPurpleAccent,
    this.curve = Curves.easeInOut, // default curve
  }) : super(key: key);

  @override
  State<SquareLoader> createState() => _SquareLoaderState();
}

class _SquareLoaderState extends State<SquareLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.speed * 1000).toInt()),
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
            painter: _SquarePainter(
              progress: _animation.value,
              stroke: widget.stroke,
              strokeLength: widget.strokeLength,
              bgColor: widget.bgColor,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _SquarePainter extends CustomPainter {
  final double progress;
  final double stroke;
  final double strokeLength;
  final Color bgColor;
  final Color color;

  _SquarePainter({
    required this.progress,
    required this.stroke,
    required this.strokeLength,
    required this.bgColor,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.height - stroke,
    );

    final paintTrack = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = bgColor;

    final paintCar = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.square
      ..color = color;

    canvas.drawRect(rect, paintTrack);

    final totalLength = rect.width * 4;
    final dashLength = totalLength * strokeLength;
    final gapLength = totalLength - dashLength;
    final dashOffset = totalLength * progress;

    final path = Path()..addRect(rect);
    final dashPath = _createDashPath(path, dashLength, gapLength, dashOffset);

    canvas.drawPath(dashPath, paintCar);
  }

  Path _createDashPath(
      Path source, double dashLength, double gapLength, double offset) {
    final metrics = source.computeMetrics().toList();
    final Path path = Path();
    for (final metric in metrics) {
      double distance = -offset;
      while (distance < metric.length) {
        final double start = max(distance, 0);
        final double end = min(distance + dashLength, metric.length);
        if (start < end) {
          path.addPath(metric.extractPath(start, end), Offset.zero);
        }
        distance += dashLength + gapLength;
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant _SquarePainter oldDelegate) => true;
}
