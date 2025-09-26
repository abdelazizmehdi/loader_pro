import 'package:flutter/material.dart';

class PingLoader extends StatefulWidget {
  final double size;
  final double speed; // بالثواني
  final Color color;
  final Curve curve; // new curve parameter

  const PingLoader({
    Key? key,
    this.size = 40,
    this.speed = 1.5,
    this.color = Colors.deepPurpleAccent, // updated default color
    this.curve = Curves.easeInOut,        // default curve
  }) : super(key: key);

  @override
  State<PingLoader> createState() => _PingLoaderState();
}

class _PingLoaderState extends State<PingLoader>
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
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildCircle(0.0),
        _buildCircle(0.5), // الثانية تبدأ متأخرة نصف دورة
      ],
    );
  }

  Widget _buildCircle(double delay) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        final value = (_animation.value + delay) % 1.0;
        final scale = value;
        final opacity = 1.0 - value;

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
              ),
            ),
          ),
        );
      },
    );
  }
}
