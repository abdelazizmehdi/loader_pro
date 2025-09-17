import 'package:flutter/material.dart';
import 'package:loader_pro/src/loader_types.dart';
import 'package:loader_pro/src/loaders/ping_loader.dart';
import 'loaders/square_loader.dart';
import 'loaders/reuleaux_loader.dart';
import 'loaders/squircle_loader.dart';
import 'loaders/pulsar_loader.dart';
import 'loaders/ripples_loader.dart';
import 'loaders/line_wobble_loader.dart';


class LoaderPro extends StatelessWidget {
  final LoaderProType type;
  final double size;
  final double speed;
  final Color color;

  const LoaderPro({
    super.key,
    this.type = LoaderProType.square,
    this.size = 40,
    this.speed = 1.2,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case LoaderProType.square:
        return SquareLoader(size: size, speed: speed, color: color);
      case LoaderProType.reuleaux:
        return ReuleauxLoader(size: size, speed: speed, color: color);
      case LoaderProType.squircle:
        return SquircleLoader(size: size, speed: speed, color: color);
      case LoaderProType.pulsar:
        return PulsarLoader(size: size, speed: speed, color: color);
      case LoaderProType.ripples:
        return RipplesLoader(size: size, speed: speed, color: color);
      case LoaderProType.lineWobble:
        return LineWobbleLoader(size: size, speed: speed, color: color);
      case LoaderProType.ping:
        return PingLoader(size: size, speed: speed, color: color);
    }
  }
}
