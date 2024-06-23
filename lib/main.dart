import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import 'package:office1/signup_data.dart'; // Import the Try widget from try.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello World App',
      home: Abc(), // Set Abc as the initial screen
    );
  }
}

class Abc extends StatelessWidget {
  const Abc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset("assets/A.json"), // Load Lottie animation
          ),
        ],
      ),
      nextScreen: SignUpScreen(), // Navigate to Try widget after splash screen
      splashIconSize: 400,
    );
  }
}
