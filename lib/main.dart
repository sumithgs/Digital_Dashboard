import 'package:flutter/material.dart';
import 'package:hel/provider/theme_provider.dart';
import 'package:hel/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _channel = WebSocketChannel.connect(
    Uri.parse('//put ur'),
  );
  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          theme: MyThemes.lightTheme,
          home: StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  final response = jsonDecode(snapshot.data.toString());
                  return DashboardScreen(
                    speed: response['speedometer'].toDouble(),
                    battery: response['battery_percentage'],
                    faults: response['faults'],
                    mode: response['mode'],
                  );
                }

                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).iconTheme.color,
                  ),
                );
              }),
          themeMode: themeProvider.themeMode,
          darkTheme: MyThemes.darkTheme,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
