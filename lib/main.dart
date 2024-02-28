import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_calculator/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

const lightBlue = Color(0xff29A8FF);
const darkBlue = Color(0xff005DB2);
const grey = Color(0xff616161);
const lightGrey = Color(0xffA5A5A5);
const lightBlack = Color(0xff303136);

const lightModeOpr = Color(0xffADE2FF);
const lightModeEqual = Color(0xff19ACFF);

num evaluateEquation(num n1, String opr, num n2){
  switch (opr){
    case '+':
      return n1 + n2;
    case '-':
      return n1 - n2;
    case '*':
      return n1 * n2;
    case '/':
      return n1 / n2;
  // Add more cases for other operators as needed
    default:
      throw ArgumentError('Invalid operator: $opr');
  }
}

String evaluate(num n1, String opr, num n2) {
  double number = double.parse(evaluateEquation(n1, opr, n2).toString());
  if (number == number.toInt()) {
    return number.toInt().toString(); // Return integer if no fractional part
  } else {
    return double.parse(number.toStringAsFixed(2)).toString(); // Return double with limited decimal points
  }
}

class Calculator extends StatefulWidget {
  Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String equation = '';
  String num1 = '', num2 = '';
  String opr = '';
  bool isAnswer = false;
  bool isLightMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLightMode? Color(0xffF7F8FB):Colors.black,
      floatingActionButton: Switch(
        value: isLightMode,
        activeColor: Color(0xff109DFF),
        onChanged: (value) {
         setState(() {
           isLightMode = value;
         });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 33.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    equation,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: isAnswer? grey : Colors.transparent,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    isAnswer? '=$num1' : equation,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      color: isLightMode? Colors.black : Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          button(child: SvgPicture.asset('assets/icons/e.svg'), color: isLightMode? Colors.white:lightBlack),
                          button(child: SvgPicture.asset('assets/icons/mu.svg'), color: isLightMode? Colors.white:lightBlack),
                          button(child: SvgPicture.asset('assets/icons/sin.svg'), color: isLightMode? Colors.white:lightBlack),
                          button(child: SvgPicture.asset('assets/icons/deg.svg'), color: isLightMode? Colors.white:lightBlack),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          button(child: coloredText('Ac', lightGrey, 32), color: isLightMode? Colors.white:grey,
                            onPressed: (){
                              setState(() {
                                equation = '';num1='';num2='';opr='';
                              });
                            }
                          ),
                          button(child: SvgPicture.asset('assets/icons/backspace.svg'), color: isLightMode? Colors.white:grey,
                            onPressed: (){
                              setState(() {
                                if (isAnswer){
                                  equation = '';num1='';num2='';opr='';
                                  isAnswer = false;
                                  return;
                                }
                                equation = equation.substring(0, equation.length-1);
                                if(opr.isNotEmpty){
                                  if(num2.isNotEmpty){
                                    num2 = num2.substring(0, num2.length-1);
                                  }
                                  else {
                                    opr = '';
                                  }
                                }
                                else{
                                  num1 = num1.substring(0, num1.length-1);
                                }
                              });
                            }
                          ),
                          button(child: coloredText('/', lightBlue), color: isLightMode? lightModeOpr:darkBlue,
                              onPressed: (){handleOperation('/');}
                          ),
                          button(child: coloredText('*', lightBlue), color: isLightMode? lightModeOpr:darkBlue,
                              onPressed: (){handleOperation('*');}
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          button(child: coloredText('7', lightBlue), color: isLightMode? Colors.white:lightBlack,
                            onPressed: (){handleNumber('7');}
                          ),
                          button(child: coloredText('8', lightBlue), color: isLightMode? Colors.white:lightBlack,
                              onPressed: (){handleNumber('8');}
                          ),
                          button(child: coloredText('9', lightBlue), color: isLightMode? Colors.white:lightBlack,
                              onPressed: (){handleNumber('9');}
                          ),
                          button(child: coloredText('-', lightBlue), color: isLightMode? lightModeOpr:darkBlue,
                              onPressed: (){handleOperation('-');}
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          button(child: coloredText('4', lightBlue), color: isLightMode? Colors.white:lightBlack,
                              onPressed: (){handleNumber('4');}
                          ),
                          button(child: coloredText('5', lightBlue), color: isLightMode? Colors.white:lightBlack,
                              onPressed: (){handleNumber('5');}
                          ),
                          button(child: coloredText('6', lightBlue), color: isLightMode? Colors.white:lightBlack,
                              onPressed: (){handleNumber('6');}
                          ),
                          button(child: coloredText('+', lightBlue), color: isLightMode? lightModeOpr:darkBlue,
                              onPressed: (){handleOperation('+');}
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      button(child: coloredText('1', lightBlue), color: isLightMode? Colors.white:lightBlack,
                                          onPressed: (){handleNumber('1');}
                                      ),
                                      button(child: coloredText('2', lightBlue), color: isLightMode? Colors.white:lightBlack,
                                          onPressed: (){handleNumber('2');}
                                      ),
                                      button(child: coloredText('3', lightBlue), color: isLightMode? Colors.white:lightBlack,
                                          onPressed: (){handleNumber('3');}
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            button(child: coloredText('0', lightBlue), color: isLightMode? Colors.white:lightBlack,
                                                onPressed: (){handleNumber('0');}
                                            ),
                                          ],
                                        ),
                                      ), 
                                      button(child: coloredText('.', lightBlue), color: isLightMode? Colors.white:lightBlack),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                button(child: coloredText('=', Colors.white), color: isLightMode? lightModeEqual:lightBlue,
                                  onPressed: (){
                                    setState(() {
                                      if (num2.isNotEmpty){
                                        num1 = evaluate(num.parse(num1), opr, num.parse(num2));
                                        isAnswer = true;
                                        num2='';opr='';
                                      }
                                    });
                                  }
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleOperation(String operation) {
    setState(() {
      if (opr.isNotEmpty) {
        if (num2.isNotEmpty) {
          print('num1: $num1, num2: $num2');
          num1 = evaluate(num.parse(num1), opr, num.parse(num2)).toString();
          equation = num1+operation;
          opr = operation;
          num2 = '';
          print('$equation');
        }
      } else {
        if (num1.isNotEmpty) {
          opr = operation;
          equation = num1+opr;
          print('$equation');
          isAnswer = false;
        }
      }
    });
  }

  void handleNumber(String number) {
    setState(() {
      if (opr.isEmpty){
        num1+= number;
        equation = num1;
        isAnswer = false;
      }
      else {
        num2 += number;
        equation += number;
      }
    });
  }
}
