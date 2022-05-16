import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  bool get isDarkMode => themeMode == ThemeMode.dark;
  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: const ColorScheme.dark(),
    primaryColor: Colors.white,
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Colors.white,
        fontSize: 64,
      ),
      headline2: TextStyle(
        color: Colors.white,
        fontSize: 30,
      ),
      bodyText1: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      bodyText2: TextStyle(
        color: Colors.white70,
        fontSize: 16,
      ),
      subtitle1: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.purple.shade200,
      opacity: 0.8,
    ),
  );
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(),
    primaryColor: Colors.black,
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Colors.black,
        fontSize: 64,
      ),
      headline2: TextStyle(
        color: Colors.black,
        fontSize: 30,
      ),
      bodyText1: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      bodyText2: TextStyle(
        color: Colors.black87,
        fontSize: 16,
      ),
      subtitle1: TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.red,
      opacity: 0.8,
    ),
  );
}
