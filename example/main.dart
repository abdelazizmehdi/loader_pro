import 'package:flutter/material.dart';
import 'package:loader_pro/loader_pro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: LoaderPro(
            type: LoaderProType.pulsar,
            size: 40,
            speed: 1.75,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
