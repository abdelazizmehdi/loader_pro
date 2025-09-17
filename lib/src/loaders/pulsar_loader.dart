import 'package:flutter/material.dart';

class PulsarLoader extends StatefulWidget {
  final double size;
  final double speed;
  final Color color;

  const PulsarLoader({
    Key? key,
    this.size = 40,
    this.speed = 1.75,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  State<PulsarLoader> createState() => _PulsarLoaderState();
}

class _PulsarLoaderState extends State<PulsarLoader>
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildCircle(delay: 0.0),
          _buildCircle(delay: 0.5), // الثانية تتأخر نصف الوقت
        ],
      ),
    );
  }

  Widget _buildCircle({required double delay}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final value = (_controller.value + delay) % 1.0; // 0 → 1
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
