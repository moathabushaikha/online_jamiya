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
      color: Colors.indigo[200],
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
    bodyText2: GoogleFonts.openSans(
      color: Colors.indigo[400],
      fontSize: 15,
      fontWeight: FontWeight.w700,
    ),
    headline1: GoogleFonts.openSans(
      color: Colors.indigo[400],
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
    ),
    headline2: GoogleFonts.openSans(
      fontSize: 21.0,
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
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.green[50],
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
        backgroundColor: Colors.white,
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
          backgroundColor: Colors.green[50],
          foregroundColor: Colors.black,
        ),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      cardColor: Colors.grey.shade800,
      scaffoldBackgroundColor: Colors.grey[900],
      backgroundColor: Colors.black26,
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
        style: ButtonStyle(
          padding: const MaterialStatePropertyAll(EdgeInsets.all(20)),
          elevation: const MaterialStatePropertyAll(12.0),
          backgroundColor: const MaterialStatePropertyAll(Colors.indigo),
          shape: MaterialStateProperty.all(
            const CircleBorder(
              side: BorderSide(
                color: Colors.white54,
                width: 3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
