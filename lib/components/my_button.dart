import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Color textcolor;
  final double textsize;
  final FontWeight fontWeight;
  final double letterspacing;
  final double buttonwidth;
  final double buttonheight;
  final Color buttoncolor;
  final Color borderColor; 
  final double radius;
  final double borderWidth; 
  final VoidCallback onTap;

  MyButton({
    required this.text,
    required this.textcolor,
    required this.textsize,
    required this.fontWeight,
    required this.letterspacing,
    required this.buttonwidth,
    required this.buttonheight,
    required this.buttoncolor,
    required this.borderColor,
    required this.radius,
    required this.borderWidth,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonheight,
      width: buttonwidth,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttoncolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(color: borderColor, width: borderWidth),
          ),
        ),
        onPressed: onTap,
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(fontSize: textsize, color: textcolor),
            textScaler: TextScaler.linear(1),
          ),
        ),
      ),
    );
  }
}
