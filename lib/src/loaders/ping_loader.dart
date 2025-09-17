import 'package:flutter/material.dart';

class PingLoader extends StatefulWidget {
  final double size;
  final double speed; // بالثواني
  final Color color;

  const PingLoader({
    Key? key,
    this.size = 40,
    this.speed = 1.5,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  State<PingLoader> createState() => _PingLoaderState();
}

class _PingLoaderState extends State<PingLoader>
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
      animation: _controller,
      builder: (_, __) {
        final value = (_controller.value + delay) % 1.0;
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
