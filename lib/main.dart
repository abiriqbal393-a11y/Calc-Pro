import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalcPro());
}

class CalcPro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalcPro',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String result = '0';

  void buttonPressed(String text) {
    setState(() {
      if (text == 'C') {
        input = '';
        result = '0';
      } else if (text == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(input.replaceAll('×', '*').replaceAll('÷', '/'));
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          result = eval.toString();
        } catch (e) {
          result = 'Error';
        }
      } else {
        input += text;
      }
    });
  }

  Widget buildButton(String text) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ElevatedButton(
          onPressed: () => buttonPressed(text),
          child: Text(text, style: TextStyle(fontSize: 24)),
          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CalcPro')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(input, style: TextStyle(fontSize: 32)),
                  Text(result, style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Column(children: [
            Row(children: [buildButton('7'), buildButton('8'), buildButton('9'), buildButton('÷')]),
            Row(children: [buildButton('4'), buildButton('5'), buildButton('6'), buildButton('×')]),
            Row(children: [buildButton('1'), buildButton('2'), buildButton('3'), buildButton('-')]),
            Row(children: [buildButton('C'), buildButton('0'), buildButton('='), buildButton('+')]),
          ]),
        ],
      ),
    );
  }
}
