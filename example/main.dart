// import 'package:flutter/material.dart';
// import 'package:loader_pro/loader_pro.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: Colors.white,
//         body: Center(
//           child: LoaderPro(
//             type: LoaderProType.pulsar,
//             size: 40,
//             speed: 1.75,
//             stroke: 4,
//             color: Colors.deepPurpleAccent,
//             bgColor: Colors.deepPurpleAccent.withOpacity(0.2),
//             curve: Curves.bounceInOut,
//           ),
//         ),
//       ),
//     );
//   }
// }

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
      debugShowCheckedModeBanner: false,
      home: const LoaderGridPage(),
    );
  }
}

class LoaderGridPage extends StatelessWidget {
  const LoaderGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    // All loader types
    final loaderTypes = LoaderProType.values;

    return Scaffold(
      appBar: AppBar(
        title: const Text("LoaderPro Showcase"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6, // max loaders per row
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 1,
          ),
          itemCount: loaderTypes.length,
          itemBuilder: (context, index) {
            final type = loaderTypes[index];
            return Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                LoaderPro(
                  type: type,
                  size: (index > 9) ?30 :50,
                  speed: (index == 9) ? 1 : 3,
                  stroke: 6,
                  color: Colors.deepPurpleAccent,
                  bgColor: Colors.deepPurpleAccent.withOpacity(0.2),
                  curve: Curves.linear,
                ),
                // const SizedBox(height: 8),
                Spacer(),

                Text(
                  type.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
