import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
      // İsterseniz buradan shared preferences vb. ile kalıcı hale getirebilirsiniz
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Not Defteri',
      theme: _isDark ? ThemeData.dark() : ThemeData.light(),
      home: SplashScreen(
        isDark: _isDark,
        themeChange: _toggleTheme,
      ),
    );
  }
}
