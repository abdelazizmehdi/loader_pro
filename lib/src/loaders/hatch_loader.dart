import 'dart:math';
import 'package:flutter/material.dart';

class HatchLoader extends StatefulWidget {
  final double size;
  final double stroke;
  final double speed; // seconds per loop
  final Color color;
  final Curve curve; // animation curve

  const HatchLoader({
    Key? key,
    this.size = 28,
    this.stroke = 4,
    this.speed = 3.5,
    this.color = Colors.deepPurpleAccent,
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  State<HatchLoader> createState() => _HatchLoaderState();
}

class _HatchLoaderState extends State<HatchLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final double _mult;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.speed * 1000).round()),
    )..repeat();
    _mult = widget.size / max(1.0, widget.stroke);
  }

  @override
  void didUpdateWidget(covariant HatchLoader old) {
    super.didUpdateWidget(old);
    if ((widget.speed - old.speed).abs() > 1e-6) {
      _controller.duration = Duration(
        milliseconds: (widget.speed * 1000).round(),
      );
      _controller.reset();
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<double> kTimes = const [
    0.0,
    0.125,
    0.25,
    0.375,
    0.5,
    0.625,
    0.75,
    0.875,
    1.0,
  ];

  double _interp(List<double> times, List<double> values, double t) {
    // apply the curve
    t = widget.curve.transform(t);

    if (t <= times.first) return values.first;
    if (t >= times.last) return values.last;

    for (int i = 0; i < times.length - 1; i++) {
      final a = times[i];
      final b = times[i + 1];
      if (t >= a && t <= b) {
        final vt = (t - a) / (b - a);
        return values[i] + (values[i + 1] - values[i]) * vt;
      }
    }
    return values.last;
  }

  List<double> _centerScaleX(double mult) => [1, mult, 1, 1, 1, mult, 1, 1, 1];
  List<double> _centerScaleY(double mult) => [1, 1, 1, mult, 1, 1, 1, mult, 1];

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    final stroke = widget.stroke;
    final strokePx = stroke;
    final sizePx = s;

    return SizedBox(
      width: sizePx,
      height: sizePx,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final t = _controller.value;

          final centerScaleX = _interp(kTimes, _centerScaleX(_mult), t);
          final centerScaleY = _interp(kTimes, _centerScaleY(_mult), t);

          final beforeScaleX = _interp(kTimes, _centerScaleX(_mult), t);
          final beforeScaleY = _interp(kTimes, _centerScaleY(_mult), t);

          final tAfter = (t + 0.5) % 1.0;
          final afterScaleX = _interp(kTimes, _centerScaleX(_mult), tAfter);
          final afterScaleY = _interp(kTimes, _centerScaleY(_mult), tAfter);

          final centerRect = Transform(
            alignment: Alignment.center,
            transform: Matrix4.diagonal3Values(centerScaleX, centerScaleY, 1.0),
            child: Container(
              width: strokePx,
              height: strokePx,
              color: widget.color,
            ),
          );

          final beforeRect = Transform(
            origin: Offset(0, 0),
            transform: Matrix4.diagonal3Values(beforeScaleX, beforeScaleY, 1.0),
            child: Container(
              width: strokePx,
              height: strokePx,
              color: widget.color,
            ),
          );

          final afterRect = Transform(
            origin: Offset(strokePx, strokePx),
            transform: Matrix4.diagonal3Values(afterScaleX, afterScaleY, 1.0),
            child: Container(
              width: strokePx,
              height: strokePx,
              color: widget.color,
            ),
          );

          return Stack(
            children: [
              Positioned(
                left: (sizePx / 2) - strokePx / 2,
                top: (sizePx / 2) - strokePx / 2,
                child: centerRect,
              ),
              Positioned(left: 0, top: 0, child: beforeRect),
              Positioned(
                left: sizePx - strokePx,
                top: sizePx - strokePx,
                child: afterRect,
              ),
            ],
          );
        },
      ),
    );
  }
}
