import 'package:flutter/material.dart';

class DotPulseLoader extends StatefulWidget {
  final double size;
  final double speed; // seconds per loop
  final Color color;
  final Curve curve; // optional curve

  const DotPulseLoader({
    Key? key,
    this.size = 18,
    this.speed = 1.2,
    this.color = Colors.deepPurpleAccent,
    this.curve = Curves.easeInOut,
  }) : super(key: key);

  @override
  State<DotPulseLoader> createState() => _DotPulseLoaderState();
}

class _DotPulseLoaderState extends State<DotPulseLoader>
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (_, __) {
            final delay = i * 0.2; // delay between each dot
            final progress = (_animation.value + delay) % 1.0;

            // Pulse scale calculation
            double rawScale = (progress < 0.5)
                ? (progress * 2) // 0 → 1
                : (1 - (progress - 0.5) * 2); // 1 → 0

            final scale = widget.curve.transform(rawScale);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
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
          },
        );
      }),
    );
  }
}
