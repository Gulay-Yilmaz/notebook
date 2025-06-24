import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback themeChange;

  const SplashScreen({
    super.key,
    required this.isDark,
    required this.themeChange,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            isDark: widget.isDark,
            themeChange: widget.themeChange,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Kolonun çocuklarına göre küçülmesi için
          children: [
            Text(
              'Notlarım',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Image.asset('assets/logo.png', width: 100),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
