# loader_pro

![Loader Pro Logo](doc/logo.png)

A Flutter package providing multiple modern loaders:
- 🔳 Square
- 🔵 Squircle
- 🔺 Reuleaux
- 💧 Ripples
- 📡 Ping
- ➿ LineWobble
- 🌌 Pulsar

## Example Screenshot

![Loader Pro in action](doc/screenshot.gif)

## Usage

```dart
import 'package:loader_pro/loader_pro.dart';

LoaderPro(
  type: LoaderProType.pulsar,
  size: 40,
  speed: 1.75,
  color: Colors.black,
);
