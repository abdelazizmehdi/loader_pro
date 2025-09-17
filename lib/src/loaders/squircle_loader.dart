import 'package:flutter/material.dart';

class SquircleLoader extends StatefulWidget {
  final double size;
  final double stroke;
  final double strokeLength;
  final double bgOpacity;
  final double speed;
  final Color color;

  const SquircleLoader({
    Key? key,
    this.size = 35,
    this.stroke = 5,
    this.strokeLength = 0.25,
    this.bgOpacity = 0.1,
    this.speed = 1.2,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  State<SquircleLoader> createState() => _SquircleLoaderState();
}

class _SquircleLoaderState extends State<SquircleLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.speed * 1000).toInt()),
    )..repeat();
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
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            painter: _SquirclePainter(
              progress: _controller.value,
              stroke: widget.stroke,
              strokeLength: widget.strokeLength,
              bgOpacity: widget.bgOpacity,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _SquirclePainter extends CustomPainter {
  final double progress;
  final double stroke;
  final double strokeLength;
  final double bgOpacity;
  final Color color;

  _SquirclePainter({
    required this.progress,
    required this.stroke,
    required this.strokeLength,
    required this.bgOpacity,
    required this.color,
  });

  Path _buildSquirclePath(Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    path.moveTo(0.01 * w, 0.5 * h);
    path.cubicTo(0.01 * w, 0.156 * h, 0.156 * w, 0.01 * h, 0.5 * w, 0.01 * h);
    path.cubicTo(0.844 * w, 0.01 * h, 0.99 * w, 0.156 * h, 0.99 * w, 0.5 * h);
    path.cubicTo(0.99 * w, 0.844 * h, 0.844 * w, 0.99 * h, 0.5 * w, 0.99 * h);
    path.cubicTo(0.156 * w, 0.99 * h, 0.01 * w, 0.844 * h, 0.01 * w, 0.5 * h);
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildSquirclePath(size);

    final bgPaint = Paint()
      ..color = color.withOpacity(bgOpacity)
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
  bool shouldRepaint(_SquirclePainter oldDelegate) => true;
}
