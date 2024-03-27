import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_calculator/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'stack.dart';

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
    case '×':
      return n1 * n2;
    case '÷':
      return n1 / n2;
  // Add more cases for other operators as needed
    default:
      throw ArgumentError('Invalid operator: $opr');
  }
}

String numConversion(double n) {
  double number = n;
  if (number == number.toInt()) {
    return number.toInt().toString(); // Return integer if no fractional part
  } else {
    return double.parse(number.toStringAsFixed(3)).toString(); // Return double with limited decimal points
  }
}

String removeLastChar(String str) {
  if(str.isNotEmpty)
    return str.substring(0, str.length - 1);
  return '';
}

class Calculator extends StatefulWidget {
  Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String equation = '';
  String number = '';
  String answer = '';
  int dotCounter = 0;
  bool isOpen = false;
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
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 24,
                      color: isAnswer? grey : Colors.transparent,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: isAnswer? false : true,
                    child: Row(
                      children: [
                        Text(
                          isAnswer? '=$answer' : equation,
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
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // bracketPressed(),
                          // button(child: SvgPicture.asset('assets/icons/mu.svg'), color: isLightMode? Colors.white:lightBlack),
                          // button(child: SvgPicture.asset('assets/icons/sin.svg'), color: isLightMode? Colors.white:lightBlack),
                          // button(child: SvgPicture.asset('assets/icons/deg.svg'), color: isLightMode? Colors.white:lightBlack),
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
                                equation = '';number = '';answer = '';
                                dotCounter = 0;
                                isOpen = false;isAnswer = false;
                              });
                            }
                          ),
                          // button(child: SvgPicture.asset('assets/icons/backspace.svg'), color: isLightMode? Colors.white:grey,
                          //   onPressed: (){
                          //     if (isAnswer){
                          //       equation = '';number = '';answer = '';
                          //       dotCounter = 0;
                          //       isOpen = false;isAnswer = false;
                          //     }
                          //     else {
                          //       equation = removeLastChar(equation);
                          //       number = removeLastChar(number);
                          //     }
                          //     setState(() {});
                          //   }
                          // ),
                          bracketPressed(),
                          oprPressed('÷'),
                          oprPressed('×'),
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
                          numberPressed('7'),
                          numberPressed('8'),
                          numberPressed('9'),
                          oprPressed('-'),
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
                          numberPressed('4'),
                          numberPressed('5'),
                          numberPressed('6'),
                          oprPressed('+'),
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
                                      numberPressed('1'),
                                      numberPressed('2'),
                                      numberPressed('3'),
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
                                            numberPressed('0'),
                                          ],
                                        ),
                                      ), 
                                      dotPressed(),
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
                                equalPressed(),
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

  Widget numberPressed(String number){
    return button(child: coloredText(number, lightBlue), color: isLightMode? Colors.white:lightBlack,
        onPressed: (){handleNumber(number);}
    );
  }

  void handleNumber(String char) {
    if (!isAnswer) {
      if (char == "0"){
        if (number.isEmpty){
          number+=char;
          equation += number;
        }
        else if (!(number.length == 1 && equation[0] == '0')){
          number +=char;
          equation += char;
        }
      }
      else if (char.isNotEmpty && int.tryParse(char) != null){
        number += char;
        equation += char;
      }
    }
    else {
      equation = '';number = '';answer = '';
      dotCounter = 0;
      isOpen = false;isAnswer = false;
      if (char.isNotEmpty && int.tryParse(char) != null) {
        number += char;
        equation += char;
      }
    }

    setState(() {});
  }

  Widget oprPressed(String opr){
    return button(child: coloredText(opr, lightBlue), color: isLightMode? lightModeOpr:darkBlue,
        onPressed: (){handleOperation(opr);}
    );
  }

  void handleOperation(String operation) {
    if (!isAnswer) {
      if (equation.isNotEmpty && ("0123456789".contains(equation[equation.length-1]) || equation[equation.length-1] == ')')){
        number = "";
        equation +=operation;
      }
    }
    else {
      equation = answer; number = '';answer = '';
      dotCounter = 0;
      isOpen = false;isAnswer = false;
      equation +=operation;
    }
    setState(() {});
  }

  Widget dotPressed(){
    return button(child: coloredText('.', lightBlue), color: isLightMode? Colors.white:lightBlack,
      onPressed: () {
        handleDot();
      },
    );
  }

  void handleDot(){
    if (number.isEmpty)
    {
      number += "0.";
      equation += "0.";
      dotCounter++;
    }
    else if (equation[equation.length-1] != '.' && dotCounter == 0){
      equation +='.';
      dotCounter++;
    }
    setState(() {});
  }

  Widget bracketPressed(){
    return button(child: coloredText('( )', lightBlue, 32), color: isLightMode? Colors.white:lightBlack,
      onPressed: () => handleBrackets(),
    );
  }

  void handleBrackets() {
    if (equation.isEmpty) {
      equation += '(';
      isOpen = true;
    } else if (number.isEmpty) {
      equation += '(';
      isOpen = true;
    } else {
      // Handle cases with closing bracket or unmatched closing brackets
      int closingBracketCount = 0;
      int openingBracketCount = 0;
      for (int i = 0; i < equation.length; i++) {
        if (equation[i] == '(') {
          openingBracketCount++;
        } else if (equation[i] == ')') {
          closingBracketCount++;
        }
      }

      if (closingBracketCount < openingBracketCount) {
        // Need to add a closing bracket
        equation += ')';
      } else if (equation[equation.length - 1] == ')') {
        // Handle case where a closing bracket is followed by an operator
        equation += '×('; // Add multiplication symbol before opening bracket
        number = "";
        isOpen = true;
      } else {
        // Handle first opening bracket or unmatched closing bracket message
        if (!isOpen) {
          equation += '×(';
          number = "";
          isOpen = true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Unmatched Closing Bracket')));
        }
      }
    }
    setState(() {});
  }

  Widget equalPressed(){
    return button(child: coloredText('=', Colors.white), color: isLightMode? lightModeEqual:lightBlue,
        onPressed: () => handleEqual(),
    );
  }

  void handleEqual() {
    if (equation.isNotEmpty) {
      if ("0123456789".contains(equation[equation.length - 1]) ||
          equation[equation.length - 1] == '.' ||
          equation[equation.length - 1] == ')') {
        isAnswer = true;
        if (evaluatePostfix(toPostfix(equation)) % 1 == 0.0) {
          answer = numConversion(evaluatePostfix(toPostfix(equation)));
        } else {
          answer = numConversion(evaluatePostfix(toPostfix(equation)));// equation = "";
        }
        number = "";
        isOpen = false;
        dotCounter = 0;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid Format')),
        );
      }
      setState(() {});
    }
  }

  double evaluatePostfix(String postfix) {
    var values = StackDS<double>();
    var i = 0;
    while (i < postfix.length) {
      if ("0123456789".contains(postfix[i])) {
        var j = i;
        var num = "";
        while ((j < postfix.length &&
                ("0123456789".contains(postfix[j]) || postfix[j] == '.')) &&
            postfix[j] != ' ') {
          num += postfix[j++];
        }
        i = j - 1;
        values.push(double.parse(num));
      } else {
        if (postfix[i] != ' ') {
          var a = values.pop();
          var b = values.pop();
          print("operator : ${postfix[i]}");
          print("a : $a");
          print("b : $b");
          if (postfix[i] == '(' || postfix[i] == ')') {
            while (postfix[i] == '(' || postfix[i] == ')') {
              i++;
            }
            values.push(applyOp(postfix[i], b, a));
          } else {
            print("operator before fun: ${postfix[i]}");
            values.push(applyOp(postfix[i], b, a));
          }
        }
      }
      i++;
      print("Stack: $values");
      print("i = $i, PostFix length = ${postfix.length}");
    }
    return values.top();
  }

  String toPostfix(String equation) {
    var tokens = equation.split('');
    print(tokens);
    var postFix = "";
    var ops = StackDS<String>();
    var i = 0;

    while (i < tokens.length) {
      if ("0123456789".contains(tokens[i])) {
        var j = i;
        //println("j = $j")

        while (j < tokens.length &&
            ("0123456789".contains(tokens[j]) || tokens[j] == '.')) {
          if (tokens[j] == '.') {
            var k = j + 1;
            if ("0123456789".contains(postFix[postFix.length - 1]) &&
                "0123456789".contains(tokens[k])) {
              postFix += tokens[j++];
            }
          } else
            postFix += tokens[j++];
        }
        print("postfix = $postFix");
        i = j - 1;
        postFix += " ";
        //println("i = $i")
      } else {
        print("symbol = ${tokens[i]}");
        if ((ops.isEmpty() || ops.top() == '(') && tokens[i] != ')') {
          ops.push(tokens[i]);
        } else {
          if (tokens[i] == '^' && ops.top() == '^') {
            ops.push(tokens[i]);
            postFix += " ";
          } else if (opValue(tokens[i]) > opValue(ops.top())) {
            ops.push(tokens[i]);
            postFix += " ";
          } else if (tokens[i] == '(') {
            ops.push(tokens[i]);
          }
          else if (tokens[i] == ')') {
            while (!ops.isEmpty() && ops.top() != '(') {
              postFix += ops.top();
              ops.pop();
            }

            ops.pop();
          } else {
            while (!ops.isEmpty() && opValue(tokens[i]) <= opValue(ops.top())) {
              postFix += ops.top();
              ops.pop();
            }
            ops.push(tokens[i]);
            postFix += " ";
          }
        }
      }
      ops.toString();
      i++;
    }

    if (ops.size() > 0) {
      for (int j = 0; j <= ops.size(); j++) {
        postFix += ops.pop();
      }
    }
    print("Postfix: $postFix");
    return postFix;
  }

  double applyOp(String op, double a, double b) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '×': // Multiplication symbol in Dart
        return a * b;
      case '÷': // Division symbol in Dart
        {
          if (b == 0.0) throw UnsupportedError("Cannot divide by zero");
          return a / b;
        }
      case '^':
        return pow(a, b).toDouble();
      default:
        return 0.0;
    }
  }

  int opValue(String op) {
    if (op == '+' || op == '-')
      return 1;
    else if (op == '×' || op == '÷')
      return 2;
    else if (op == '^')
      return 3;
    else
      return -1;
  }
}
