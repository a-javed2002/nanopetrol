import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petrol/firebase_options.dart';
import 'package:petrol/notifiers/theme.dart';
import 'package:petrol/views/splash_screen.dart';
import 'package:petrol/views/license.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var x = prefs.getBool('isLicense') ?? false;

  // Check if default credentials are already stored
  bool credentialsStored = prefs.getBool('credentialsStored') ?? false;
  if (!credentialsStored) {
    // Store default credentials
    prefs.setString('username', 'admin');
    prefs.setString('password', '123');

    // Set a flag to indicate that default credentials are stored
    prefs.setBool('credentialsStored', true);
  }

  // Check if dataList is empty in SharedPreferences
  List<String>? dataList = prefs.getStringList('dataList');

  // If dataList is empty, add dummy data
  if (dataList == null || dataList.isEmpty) {
    // Add dummy data
    List<Map<String, String>> dummyDataList = [
      {
        'name': 'Petrol',
        'price': '10.00',
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
      },
      {
        'name': 'Diesel',
        'price': '20.00',
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
      },
      {
        'name': 'Octane',
        'price': '30.00',
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
      },
      {
        'name': 'Biodiesel',
        'price': '40.00',
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
      }
    ];

    // Encode dummyDataList and save to SharedPreferences
    List<String> encodedDummyDataList =
        dummyDataList.map((item) => json.encode(item)).toList();
    await prefs.setStringList('dataList', encodedDummyDataList);
  }

  runApp(MyApp(
    license: x,
  ));
}

class MyApp extends StatelessWidget {
  final bool license;
  const MyApp({super.key, required this.license});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          CompanyThemeProvider(), // Provide your CompanyThemeProvider here
      child: Consumer<CompanyThemeProvider>(
        builder: (context, themeProvider, child) {
          // Define your theme here using the colors from CompanyTheme
          final ThemeData themeData = ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.pink, brightness: Brightness.dark),
            fontFamily: "Manrope",
            scaffoldBackgroundColor:
                themeProvider.currentTheme?.mainColor ?? Colors.blue,
            primaryColor: Colors.black,
            primaryColorLight: themeProvider.currentTheme?.lightColor ??
                Colors.lightBlueAccent,
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Colors.black,
              ),
            )),
            expansionTileTheme: const ExpansionTileThemeData(
                shape: Border(), backgroundColor: Colors.black),
          );
          // final ThemeData themeData = ThemeData(
          //   primaryColor: themeProvider.currentTheme?.mainColor ?? Colors.blue, // Use mainColor from CompanyTheme
          //   secondaryHeaderColor: themeProvider.currentTheme?.lightColor ?? Colors.lightBlueAccent, // Use lightColor from CompanyTheme
          //   // Define other theme properties as needed
          // );

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeData,
            home: license
                ? SplashScreen()
                : LicenseVerificationScreen(), // Your home page widget
          );
        },
      ),
    );
  }
}

class IconicImageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iconic Image Frame'),
      ),
      // body: Container(
      //   color: Colors.blue,
      //   child: Center(
      //     child: Image.asset(
      //       'assets/logo.jpeg', // Replace with your image asset path
      //       width: 200,
      //       height: 200,
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      // ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Colors.black, width: 5),
            top: BorderSide(color: Colors.black, width: 5),
            right: BorderSide(color: Colors.black, width: 5),
            bottom: BorderSide(color: Colors.black, width: 5),
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/logo.jpeg', // Replace with your image asset path
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
