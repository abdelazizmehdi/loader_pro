import 'package:flutter/material.dart';

class RipplesLoader extends StatefulWidget {
  final double size;
  final double speed;
  final Color color;

  const RipplesLoader({
    Key? key,
    this.size = 35,
    this.speed = 1.2,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  State<RipplesLoader> createState() => _RipplesLoaderState();
}

class _RipplesLoaderState extends State<RipplesLoader>
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildCircle(0.0),
          _buildCircle(0.25),
          _buildCircle(0.5),
          _buildCircle(0.75),
        ],
      ),
    );
  }
}
