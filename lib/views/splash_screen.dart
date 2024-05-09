import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:petrol/views/home_screen.dart'; // Import your home screen here
import 'package:petrol/models/theme.dart';
import 'package:petrol/notifiers/theme.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access the company theme data using Provider
    CompanyTheme? companyTheme =
        Provider.of<CompanyThemeProvider>(context).currentTheme;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 220, // Adjust the width and height as needed
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.black,
                      width: 2.0), // Border around the circle
                ),
                child: Center(
                  // child: Lottie.asset(
                  //   'assets/fuel.json',
                  //   width: 180,
                  //   height: 180,
                  //   fit: BoxFit.cover,
                  // ),
                  child: companyTheme?.logoUrl != null
                      ? Image.file(
                          companyTheme!.logoUrl!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.contain,
                        )
                      : const Placeholder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
