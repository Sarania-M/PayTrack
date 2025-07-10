import 'package:flutter/material.dart';

ThemeData lightMode = 
ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    surface: const Color.fromARGB(255, 201, 184, 213),
    primary: const Color.fromARGB(246, 144, 99, 130),
    secondary: Colors.white,
    tertiary: const Color.fromARGB(255, 98, 50, 74),
    tertiaryContainer: const Color.fromARGB(247, 222, 213, 234),
    primaryContainer: const Color.fromARGB(255, 0, 0, 0),
    secondaryContainer: const Color.fromARGB(27, 76, 2, 60),
    surfaceContainer: const Color.fromARGB(27, 76, 2, 60),
    


  )

);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(255, 40, 13, 59),
    primary: const Color.fromARGB(255, 187, 135, 221),
    secondary: const Color.fromARGB(255, 33, 20, 54),
    tertiary: const Color.fromARGB(255, 24, 178, 155),
    tertiaryContainer: const Color.fromARGB(247, 222, 213, 234),
    primaryContainer: const Color.fromARGB(255, 254, 254, 254),
    secondaryContainer: const Color.fromARGB(135, 86, 76, 93),
    surfaceContainer: Color.fromARGB(33, 248, 202, 209),
    

   

  )

);