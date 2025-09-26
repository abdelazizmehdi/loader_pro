import 'package:flutter/material.dart';

class ReuleauxLoader extends StatefulWidget {
  final double size;
  final double stroke;
  final double strokeLength;
  final Color bgColor; // changed from bgOpacity
  final double speed;
  final Color color;
  final Curve curve;

  const ReuleauxLoader({
    Key? key,
    this.size = 37,
    this.stroke = 5,
    this.strokeLength = 0.15,
    this.bgColor = const Color(0x1A673AB7), // new background color
    this.speed = 1.2,
    this.color = Colors.deepPurpleAccent,
    this.curve = Curves.easeInOut,
  }) : super(key: key);

  @override
  State<ReuleauxLoader> createState() => _ReuleauxLoaderState();
}

class _ReuleauxLoaderState extends State<ReuleauxLoader>
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
        builder: (context, _) {
          return CustomPaint(
            painter: _ReuleauxPainter(
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

class _ReuleauxPainter extends CustomPainter {
  final double progress;
  final double stroke;
  final double strokeLength;
  final Color bgColor; // changed
  final Color color;

  _ReuleauxPainter({
    required this.progress,
    required this.stroke,
    required this.strokeLength,
    required this.bgColor,
    required this.color,
  });

  Path _buildReuleauxPath(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();

    path.moveTo(w * 0.99, h * 0.86);
    path.cubicTo(w * 0.99, h * 0.5, w * 0.8, h * 0.1, w * 0.5, 0);
    path.cubicTo(w * 0.2, h * 0.1, 0, h * 0.5, 0, h * 0.86);
    path.cubicTo(w * 0.3, h * 1.1, w * 0.7, h * 1.1, w * 0.99, h * 0.86);
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildReuleauxPath(size);
    final metric = path.computeMetrics().first;
    final length = metric.length;

    final trackPaint = Paint()
      ..color = bgColor // use bgColor instead of opacity
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    canvas.drawPath(path, trackPaint);

    final carPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final start = progress * length;
    final visibleLen = strokeLength * length;
    final end = start + visibleLen;

    if (end <= length) {
      canvas.drawPath(metric.extractPath(start, end), carPaint);
    } else {
      canvas.drawPath(metric.extractPath(start, length), carPaint);
      canvas.drawPath(metric.extractPath(0, end - length), carPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ReuleauxPainter oldDelegate) => true;
}
