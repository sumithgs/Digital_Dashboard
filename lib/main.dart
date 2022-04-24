import 'package:flutter/material.dart';
import 'package:hel/provider/theme_provider.dart';
import 'package:hel/widget/speedgauge.dart';
import 'package:hel/widget/change_theme_button.dart';
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
          home: const MyHomePage(),
          themeMode: themeProvider.themeMode,
          darkTheme: MyThemes.darkTheme,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        leading: const Icon(Icons.menu),
        elevation: 0,
        actions: const [
          ChangeThemeButtonWidget(),
        ],
      ),
      extendBody: true,
      body: const Center(
        child: Text('data'),
      ),
    );
  }
}
