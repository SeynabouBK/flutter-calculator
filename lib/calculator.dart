import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key, required this.title});

  final String title;

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  int _counter = 0;
  int increment = 2;

  void _incrementCounter() {
    setState(() {
      _counter += increment;
    });
  }

  void _gestionIncrementInput(String value) {
    if (value.isEmpty) {
      setState(() {
        increment = 2;
      });
      return;
    }

    int? newIncrement = int.tryParse(value);
    if (newIncrement == null || newIncrement <= 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erreur'),
            content: const Text(
                "La valeur de l'incrément ne doit pas être inférieure à 1"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      setState(() {
        increment = 1;
      });
    } else {
      setState(() {
        increment = newIncrement;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //// La couleur de l'AppBar est maintenant définie par appBarTheme

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Increment (+4)',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: _gestionIncrementInput),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$_counter + $increment =",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  '${_counter + increment}',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Text('+$increment'), // Remplacer l'icône par le texte "+2"
        //child: const Icon(Icons.add),
      ),
    );
  }
}
