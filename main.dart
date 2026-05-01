import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(CalcProApp());

class CalcProApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String userInput = '';
  String result = '0';

  List<String> buttons = [
    'C', '⌫', '%', '/',
    '7', '8', '9', '*',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '00', '0', '.', '=',
  ];

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        userInput = '';
        result = '0';
      } else if (buttonText == '⌫') {
        userInput = userInput.isNotEmpty
           ? userInput.substring(0, userInput.length - 1)
            : '';
      } else if (buttonText == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(userInput.replaceAll('×', '*').replaceAll('÷', '/'));
          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          if (result.endsWith('.0')) {
            result = result.substring(0, result.length - 2);
          }
        } catch (e) {
          result = 'Error';
        }
      } else {
        userInput += buttonText;
      }
    });
  }

  Widget buildButton(String buttonText) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(24),
            backgroundColor: getColor(buttonText),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Color getColor(String text) {
    if (text == '/' || text == '*' || text == '-' || text == '+' || text == '=') {
      return Colors.orange.shade600;
    }
    if (text == 'C' || text == '⌫' || text == '%') {
      return Colors.red.shade600;
    }
    return Colors.blueGrey.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Calc Pro', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    userInput,
                    style: TextStyle(fontSize: 32, color: Colors.white70),
                    maxLines: 2,
                  ),
                  SizedBox(height: 20),
                  Text(
                    result,
                    style: TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: buttons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  return buildButton(buttons[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
