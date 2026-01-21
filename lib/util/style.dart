import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  // Add the responsiveFontSize method within the Styles class
  static double responsiveFontSize(BuildContext context, double baseFontSize) {
    return MediaQuery.of(context).textScaler.scale(baseFontSize);
  }

  static TextStyle textStyleLogin(
    BuildContext context, {
    Color color = Colors.black,
    double? fontSize,
  }) {
    return GoogleFonts.roboto(
      color: color,
      fontWeight: FontWeight.w900,
      fontSize: fontSize,
      // fontSize: MediaQuery.of(context).textScaler.scale(fontSize ?? 30),
    );
  }

  static TextStyle textStyleTittle(
    BuildContext context, {
    Color color = Colors.black,
    double? fontSize,
  }) {
    return GoogleFonts.playfairDisplay(
      color: color,
      fontWeight: FontWeight.w100,
      fontSize: fontSize,
      // fontSize: MediaQuery.of(context).textScaler.scale(30),
    );
  }

  static TextStyle textStyleLarge(
    BuildContext context, {
    Color color = Colors.black,
  }) {
    return GoogleFonts.roboto(
      color: color,
      fontWeight: FontWeight.w900,
      fontSize: 40,
    );
  }

  static TextStyle textStyleVerySmall(
    BuildContext context, {
    Color color = Colors.black,
  }) {
    return GoogleFonts.dmSans(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
  }

  static TextStyle textStyleSummary(
    BuildContext context, {
    Color color = Colors.black,
  }) {
    return GoogleFonts.dmSans(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
  }

  static TextStyle textStyleSmall(
    BuildContext context, {
    Color color = Colors.black,
  }) {
    return GoogleFonts.notoSans(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    );
  }

  static TextStyle textStyleButton(
    BuildContext context, {
    Color color = const Color.fromARGB(255, 250, 248, 248),
  }) {
    return GoogleFonts.notoSans(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    );
  }

  static TextStyle textStyleButton2(
    BuildContext context, {
    Color color = const Color.fromARGB(255, 250, 248, 248),
  }) {
    return GoogleFonts.dmSans(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
  }

  static TextStyle text1(
    BuildContext context, {
    Color color = const Color.fromARGB(255, 250, 248, 248),
  }) {
    return GoogleFonts.dmSans(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
  }

  static TextStyle text2(
    BuildContext context, {
    Color color = const Color.fromARGB(255, 250, 248, 248),
  }) {
    return GoogleFonts.dmSans(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
  }

  static TextStyle text3(
    BuildContext context, {
    Color color = const Color.fromARGB(255, 250, 248, 248),
  }) {
    return GoogleFonts.dmSans(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );
  }

  static TextStyle headingtext({Color color = Colors.black}) {
    return TextStyle(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }

  // static TextStyle pincode({Color color = Colors.black}) {
  //   return TextStyle(fontSize: 35, color: color, fontWeight: FontWeight.bold);
  // }

  static TextStyle pincode({
    required BuildContext context,
    Color color = Colors.black,
  }) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: MediaQuery.textScalerOf(context).scale(18),
    );
  }
}
