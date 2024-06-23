import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package // Import the Try widget from try.dart
import 'package:office1/hero.dart'; // Import the Try widget from try.dart

void main() {
  runApp(SpinApp());
}

class SpinApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello World App',
      home: Spin(), // Set Spin as the initial screen
    );
  }
}

class Spin extends StatelessWidget {
  const Spin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset("assets/b.json"), // Load Lottie animation
          ),
        ],
      ),
      nextScreen: CustomHero(), // Navigate to Try widget after splash screen
      splashIconSize: 800,
    );
  }
}

