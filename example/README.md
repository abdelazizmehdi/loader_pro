# loader_pro

A Flutter package providing multiple modern loaders:

- Square
- Squircle
- Reuleaux
- Ripples
- Ping
- LineWobble
- Pulsar
- Star
- DotPulse
- DotStream
- Trefoil
- Hatch

## Example Screenshot

![Loader Pro in action](doc/screenshot.gif)

## Usage

```dart
import 'package:loader_pro/loader_pro.dart';

LoaderPro(
  type: LoaderProType.pulsar,
  size: 40,
  speed: 1.75,
  stroke: 4,
  color: Colors.deepPurpleAccent,
  bgColor: Colors.deepPurpleAccent.withOpacity(0.2),
  curve: Curves.bounceInOut,
);
