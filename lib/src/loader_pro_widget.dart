import 'package:flutter/material.dart';
import 'package:loader_pro/src/loader_types.dart';
import 'package:loader_pro/src/loaders/dot_pulse_loader.dart';
import 'package:loader_pro/src/loaders/dot_stream_loader.dart';
import 'package:loader_pro/src/loaders/hatch_loader.dart';
import 'package:loader_pro/src/loaders/ping_loader.dart';
import 'package:loader_pro/src/loaders/star_loader.dart';
import 'package:loader_pro/src/loaders/trefoil_loader.dart';
import 'loaders/square_loader.dart';
import 'loaders/reuleaux_loader.dart';
import 'loaders/squircle_loader.dart';
import 'loaders/pulsar_loader.dart';
import 'loaders/ripples_loader.dart';
import 'loaders/line_wobble_loader.dart';

class LoaderPro extends StatelessWidget {
  final LoaderProType type;
  final double size; // works with all
  final double speed; // works with all
  final Curve curve; // works with all
  final Color color; // works with all
  final Color
      bgColor; // works with: square, reuleaux, squircle, star, lineWobble, trefoil
  final double
      stroke; // works with: square, reuleaux, squircle, star, lineWobble, trefoil
  final double
      strokeLength; // works with: square, reuleaux, squircle, star, trefoil
  final int count; // works with: dotStream only

  const LoaderPro({
    super.key,
    this.type = LoaderProType.square,
    this.size = 40,
    this.speed = 1.2,
    this.curve = Curves.linear,
    this.color = Colors.deepPurpleAccent,
    this.bgColor = const Color(0x1A673AB7),
    this.stroke = 5,
    this.strokeLength = 0.25,
    this.count = 6,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case LoaderProType.square:
        return SquareLoader(
          size: size,
          speed: speed,
          stroke: stroke,
          strokeLength: strokeLength,
          color: color,
          curve: curve,
          bgColor: bgColor,
        );
      case LoaderProType.reuleaux:
        return ReuleauxLoader(
          size: size,
          speed: speed,
          stroke: stroke,
          strokeLength: strokeLength,
          bgColor: bgColor,
          color: color,
          curve: curve,
        );
      case LoaderProType.squircle:
        return SquircleLoader(
          size: size,
          speed: speed,
          stroke: stroke,
          strokeLength: strokeLength,
          color: color,
          bgColor: bgColor,
          curve: curve,
        );
      case LoaderProType.pulsar:
        return PulsarLoader(
          size: size,
          speed: speed,
          color: color,
          curve: curve,
        );
      case LoaderProType.ripples:
        return RipplesLoader(
          size: size,
          speed: speed,
          color: color,
          curve: curve,
        );
      case LoaderProType.lineWobble:
        return LineWobbleLoader(
          size: size,
          speed: speed,
          stroke: stroke,
          color: color,
          bgColor: bgColor,
          curve: curve,
        );
      case LoaderProType.ping:
        return PingLoader(
          size: size,
          speed: speed,
          color: color,
          curve: curve,
        );
      case LoaderProType.hatch:
        return HatchLoader(
          size: size,
          speed: speed,
          stroke: stroke,
          color: color,
          curve: curve,
        );
      case LoaderProType.dotPulse:
        return DotPulseLoader(
          size: size,
          speed: speed,
          color: color,
          curve: curve,
        );
      case LoaderProType.dotStream:
        return DotStreamLoader(
          size: size,
          speed: speed,
          color: color,
          count: count,
          curve: curve,
        );
      case LoaderProType.star:
        return StarLoader(
          size: size,
          speed: speed,
          color: color,
          stroke: stroke,
          strokeLength: strokeLength,
          bgColor: bgColor,
          curve: curve,
        );
      case LoaderProType.trefoilL:
        return TrefoilLoader(
          size: size,
          speed: speed,
          color: color,
          stroke: stroke,
          strokeLength: strokeLength,
          bgColor: bgColor,
          curve: curve,
        );
    }
  }
}
