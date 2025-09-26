import 'package:flutter/material.dart';

class LineWobbleLoader extends StatefulWidget {
  final double size;
  final double stroke;
  final double speed; // seconds
  final Color bgColor; // changed from bgOpacity
  final Color color;
  final Curve curve; // optional animation curve

  const LineWobbleLoader({
    Key? key,
    this.size = 40,
    this.stroke = 6,
    this.speed = 1.2,
    // deepPurpleAccent with ~20% opacity (0x33 = 51/255 ≈ 20%)
    this.bgColor = const Color(0x33673AB7),
    this.color = Colors.deepPurpleAccent,
    this.curve = Curves.easeInOut,
  }) : super(key: key);

  @override
  State<LineWobbleLoader> createState() => _LineWobbleLoaderState();
}

class _LineWobbleLoaderState extends State<LineWobbleLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.speed * 1000).toInt()),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        final dx = _animation.value * (widget.size / 2 - widget.stroke / 2);

        return SizedBox(
          width: widget.size,
          height: widget.stroke,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: widget.size,
                height: widget.stroke,
                decoration: BoxDecoration(
                  color: widget.bgColor,
                  borderRadius: BorderRadius.circular(widget.stroke / 2),
                ),
              ),
              Transform.translate(
                offset: Offset(dx, 0),
                child: Container(
                  width: widget.size,
                  height: widget.stroke,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(widget.stroke / 2),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
