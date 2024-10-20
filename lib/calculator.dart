import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Operation { add, multiply, subtract, divide }

class Calculator extends StatefulWidget {
  final String title;
  const Calculator({super.key, required this.title});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  int _counter =
      0; // Initialisation à 0, ajustée lors de la sélection de l'opération
  int _clickCount = 0; // Suivi du nombre de clics
  int increment = 2; // Valeur initiale de l'incrément
  Operation _selectedOperation = Operation.add; // Opération initiale
  final TextEditingController _incrementController = TextEditingController(
      text: '2'); // Initialisation avec la valeur par défaut

  void _incrementCounter() {
    setState(() {
      // Gestion du compteur pour le premier clic sur des opérations autres que l'addition
      if (_clickCount == 0 && _selectedOperation != Operation.add) {
        _counter = 2;
      }

      // Calcul selon l'opération sélectionnée
      switch (_selectedOperation) {
        case Operation.add:
          _counter += increment;
          break;
        case Operation.multiply:
          _counter *= increment;
          break;
        case Operation.subtract:
          _counter -= increment;
          break;
        case Operation.divide:
          if (increment != 0) {
            _counter ~/= increment;
          } else {
            _showErrorDialog('Division par zéro non permise');
          }
          break;
      }
      _clickCount +=
          1; // Incrémentation: le compteur de clics après l'opération
    });
  }

  void _gestionIncrementInput(String value) {
    if (value.isEmpty) {
      setState(() {
        increment =
            2; // Réinitialisation de l'incrément à 2 si le champ est vide
        _incrementController.text =
            '2'; // Réinitialise également le champ de texte
      });
      return;
    }

    int? newIncrement = int.tryParse(value);
    if (newIncrement == null || newIncrement < 1) {
      _showErrorDialog('Les valeurs inférieures à 1 ne sont pas permises');
      setState(() {
        increment = 1; // Fixation de l'incrément à 1 si inférieur à 1
        _incrementController.text =
            '1'; // Réinitialise le champ de texte à 1 pour l'addition
      });
      return;
    }

    setState(() {
      increment = newIncrement;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<Operation>(
              value: _selectedOperation,
              onChanged: (Operation? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedOperation = newValue;
                    _counter = newValue == Operation.add
                        ? 0
                        : 2; // Ajustement du compteur pour l'opération
                    _clickCount =
                        0; // Réinitialisation du compteur de clics lors du changement d'opération
                    increment =
                        2; // Réinitialisation de l'incrément à 2 à chaque changement d'opération
                    _incrementController.text =
                        '2'; // Réinitialise le texte du champ à chaque changement d'opération
                  });
                }
              },
              items: Operation.values.map((Operation operation) {
                return DropdownMenuItem<Operation>(
                  value: operation,
                  child: Text(operation.toString().split('.').last),
                );
              }).toList(),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Increment',
                hintText: 'Enter a value',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ], // je assure que seuls les nombres entiers sont entrés
              onChanged: _gestionIncrementInput,
            ),
            Text('Operation: ${_selectedOperation.toString().split('.').last}'),
            Text('Increment: $increment'),
            Text(
                '$_counter ${_getOperationSymbol()} $increment = ${_calculateNewValue()}',
                style: Theme.of(context).textTheme.headlineLarge),
            if (_clickCount > 0) Text('Vous avez cliqué $_clickCount fois')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Operate',
        child: Icon(_selectedOperation == Operation.add
            ? Icons.add
            : _selectedOperation == Operation.multiply
                ? Icons.clear
                : _selectedOperation == Operation.subtract
                    ? Icons.remove
                    : Icons.safety_divider),
      ),
    );
  }

  String _getOperationSymbol() {
    switch (_selectedOperation) {
      case Operation.add:
        return "+";
      case Operation.multiply:
        return "*";
      case Operation.subtract:
        return "-";
      case Operation.divide:
        return "/";
      default:
        return "";
    }
  }

  int _calculateNewValue() {
    // Calcul du résultat en fonction de l'opération pour affichage
    switch (_selectedOperation) {
      case Operation.add:
        return _counter + increment;
      case Operation.multiply:
        return _counter * increment;
      case Operation.subtract:
        return _counter - increment;
      case Operation.divide:
        return increment != 0 ? _counter ~/ increment : _counter;
      default:
        return _counter;
    }
  }
}
