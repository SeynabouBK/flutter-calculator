import 'package:flutter/material.dart';
import 'calculator.dart'; // Import de la classe Calculator

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
          //Personnalisation de la couleur de l appBar
          appBarTheme: const AppBarTheme(
            backgroundColor:
                Colors.pink, // specificatin de la couleur souhaitee
          )),
      home: const Calculator(title: 'Calculator'),
    );
  }
}
