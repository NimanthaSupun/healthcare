import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/constants/colors.dart';

class ThemesModeData {
  final ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    fontFamily: GoogleFonts.actor().fontFamily,
    primaryColor: const Color(0xFF0D70E6),
    scaffoldBackgroundColor: const Color(0xFFF5FAFB),
    cardColor: const Color(0xFFF5FAFB),
    dividerColor: const Color(0x1F171D1E),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF0D70E6),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF4A6267),
      onSecondary: Color(0xFFFFFFFF),
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      surface: Color(0xFFF5FAFB),
      onSurface: Color(0xFF171D1E),
    ),
    cardTheme: CardTheme(
      color: Color.fromRGBO(249, 255, 255, 1),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedLabelStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w600,
      ),
      selectedItemColor: blueColor,
      unselectedItemColor: Colors.grey,
    ),
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    appBarTheme: const AppBarTheme(
      color: Color(0xFFF5FAFB),
      iconTheme: IconThemeData(
        color: Color.fromRGBO(0, 0, 0, 1),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Color(0xFF171D1E),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF171D1E),
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      titleLarge: TextStyle(
        color: Color(0xFF171D1E),
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
    ),
  );

  final ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.actor().fontFamily,
    primaryColor: const Color(0xFF111418),
    scaffoldBackgroundColor: const Color(0xFF111418),
    cardColor: const Color(0xFF111418),
    // cardColor: const Color.fromARGB(255, 129, 163, 207),
    dividerColor: const Color(0x1FE1E2E8),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF37A1FD),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFFBBC7DB),
      onSecondary: Color(0xFF253140),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      surface: Color(0xFF111418),
      onSurface: Color(0xFFE1E2E8),
    ),
    cardTheme: CardTheme(
      // color: Colors.grey.withAlpha(1),
      color: Color.fromRGBO(0, 0, 0, 1),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedLabelStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w600,
      ),
      selectedItemColor: blueColor,
      unselectedItemColor: mainWhiteColor,
    ),
    snackBarTheme: SnackBarThemeData(
      contentTextStyle:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
    ),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF111418),
      iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Color(0xFFE1E2E8),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFFE1E2E8),
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      titleLarge: TextStyle(
        color: Color(0xFFE1E2E8),
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
    ),
  );

//   // todo: -------------------------LIGHT MODE------------------------------------

//   final ThemeData lightMode = ThemeData(

//     brightness: Brightness.light,
//     fontFamily: GoogleFonts.poppins().fontFamily,
//     primarySwatch: Colors.blue,
//     appBarTheme: AppBarTheme(
//       backgroundColor: Colors.white,
//       titleTextStyle: TextStyle(
//         color: Colors.black,
//         fontFamily: GoogleFonts.poppins().fontFamily,
//         fontSize: 20,
//       ),
//     ),

//     iconTheme: const IconThemeData(
//       color: Colors.black,
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(20),
//         borderSide: const BorderSide(
//           color: Colors.black
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(20),
//         borderSide: const BorderSide(
//           color: Colors.black,
//         ),
//       ),
//        enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(20),
//         borderSide: const BorderSide(
//           color: Colors.black,
//         ),
//       ),
//     ),
//     scaffoldBackgroundColor: Colors.white,
//   );

//   // todo:----------------------DARK MODE --------------------------------------------
//   final ThemeData darkMode = ThemeData(

//     brightness: Brightness.dark,
//     fontFamily: GoogleFonts.poppins().fontFamily,
//     primarySwatch: Colors.deepPurple,
//     appBarTheme: AppBarTheme(
//       backgroundColor: const Color.fromARGB(255, 21, 21, 21),
//       titleTextStyle: TextStyle(
//         color: Colors.white,
//         fontFamily: GoogleFonts.poppins().fontFamily,
//         fontSize: 20,
//       ),
//       iconTheme: const IconThemeData(
//         color: Colors.white,
//       ),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(20),
//         borderSide: const BorderSide(
//           color: Colors.white,
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(20),
//         borderSide: const BorderSide(
//           color: Colors.white,
//         ),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(20),
//         borderSide: const BorderSide(
//           color: Colors.white,
//         ),
//       ),
//     ),
//     // scaffoldBackgroundColor: const Color.fromARGB(255, 21, 21, 21),
//     scaffoldBackgroundColor: Colors.black
//   );
}
