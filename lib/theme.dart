import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JamiyaTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.openSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headline1: GoogleFonts.openSans(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headline2: GoogleFonts.openSans(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headline3: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headline6: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    button: GoogleFonts.openSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.openSans(
      color: Colors.indigo[50],
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
    bodyText2: GoogleFonts.openSans(
      color: Colors.indigo[50],
      fontSize: 8,
      fontWeight: FontWeight.w700,
    ),
    headline1: GoogleFonts.openSans(
      color: Colors.indigo[50],
      fontSize: 26.0,
      fontWeight: FontWeight.bold,
    ),
    headline2: GoogleFonts.openSans(
      fontSize: 18.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline3: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.indigo.shade200,
    ),
    headline6: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.black12,
    ),
    button: GoogleFonts.openSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
  );

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith(
          (states) {
            return Colors.black;
          },
        ),
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.green,
      ),
      textTheme: lightTextTheme,
      buttonTheme: const ButtonThemeData(buttonColor: Colors.green),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          side: const BorderSide(width: 2),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 10,
          textStyle: const TextStyle(color: Colors.black),
          backgroundColor: const Color.fromRGBO(255, 255, 255, 0.1),
          foregroundColor: Colors.black,
        ),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      cardColor: Colors.grey.shade800,
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900],
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.white24,
        unselectedItemColor: Colors.black54,
      ),
      textTheme: darkTextTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 10,
          textStyle: const TextStyle(color: Colors.white),
          backgroundColor: const Color.fromRGBO(100, 150, 255, 0.3),
        ),
      ),
    );
  }
}
