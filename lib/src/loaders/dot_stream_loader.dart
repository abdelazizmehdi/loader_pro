import 'package:flutter/material.dart';

class DotStreamLoader extends StatefulWidget {
  final double size;
  final int count;
  final double speed; // seconds per loop
  final Color color;
  final Curve curve; // optional curve

  const DotStreamLoader({
    Key? key,
    this.size = 12,
    this.count = 6,
    this.speed = 1.5,
    this.color = Colors.deepPurpleAccent,
    this.curve = Curves.easeInOut,
  }) : super(key: key);

  @override
  State<DotStreamLoader> createState() => _DotStreamLoaderState();
}

class _DotStreamLoaderState extends State<DotStreamLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

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
    final totalWidth = widget.size * 8;
    final totalHeight = widget.size * 2;

    return SizedBox(
      width: totalWidth,
      height: totalHeight,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (_, __) {
          return Stack(
            children: List.generate(widget.count, (i) {
              final delay = i / widget.count;
              final progress = (_animation.value + delay) % 1.0;

              final dx = (1 - progress) * (widget.size * 6);
              final scale = 0.001 + (1 - (2 * (progress - 0.5)).abs());

              return Positioned(
                left: dx,
                top: widget.size * 0.5,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
