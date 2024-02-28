import 'package:flutter/material.dart';

const lightBlue = Color(0xff29A8FF);
const lightGrey = Color(0xffA5A5A5);

Text coloredText(String txt, Color color, [double fontSize = 32]) {
  return Text(
    txt,
    style: TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    ),
  );
}

Text whiteText(String txt) {
  return Text(
    txt,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 32,
      color: Colors.white,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget button({required Widget child, required Color color, Function()? onPressed}) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: MaterialButton(
        padding: EdgeInsets.all(0),
        onPressed: (onPressed==null)? (){}: onPressed,
        elevation: 0,
        clipBehavior: Clip.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: color,
        child: child,
      ),
    ),
  );
}


