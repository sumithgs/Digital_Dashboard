import 'package:flutter/material.dart';
import 'package:hel/provider/theme_provider.dart';
import 'package:hel/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          theme: MyThemes.lightTheme,
          home: const DashboardScreen(),
          themeMode: themeProvider.themeMode,
          darkTheme: MyThemes.darkTheme,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
