// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:office1/login_data.dart';
import 'package:office1/hero.dart';
import 'package:office1/spinner.dart';

void main() {
  runApp(const MaterialApp(
    home: SignUpScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  Future<void> signUp() async {
    String url =
        'http://10.0.2.2/office1/process.php'; // Replace with your server URL
    try {
      var response = await http.post(Uri.parse(url), body: {
        "signup_submit": "1",
        "signup_username": usernameController.text,
        "signup_email": emailController.text,
        "signup_password": passwordController.text,
      });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        showToast(jsonData['message']);
      } else {
        showToast("Error: ${response.statusCode}");
      }
    } catch (e) {
      showToast("An error occurred: $e");
    }
  }

  Future<void> verifyOTP() async {
    String url =
        'http://10.0.2.2/office1/process.php'; // Replace with your server URL
    try {
      var response = await http.post(Uri.parse(url), body: {
        "verify_otp": "1",
        "signup_email": emailController.text,
        "entered_otp": otpController.text,
      });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        showToast(jsonData['message']);
        if (jsonData['status'] == "success") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SpinApp()),
          );
        }
      } else {
        showToast("Error: ${response.statusCode}");
      }
    } catch (e) {
      showToast("An error occurred: $e");
    }
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: signUp,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Sign Up', style: TextStyle(fontSize: 18.0)),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: otpController,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                  prefixIcon: Icon(Icons.security),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: verifyOTP,
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Verify OTP', style: TextStyle(fontSize: 18.0)),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginApp()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey,
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Login', style: TextStyle(fontSize: 18.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
