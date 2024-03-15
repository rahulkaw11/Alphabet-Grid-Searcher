import 'package:alphabet_grid_searcher/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alphabet Searcher',
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.blue,selectionColor: Colors.blue,selectionHandleColor: Colors.blue),
        fontFamily: 'Exo Regular',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

