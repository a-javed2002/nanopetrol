import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petrol/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Check if default credentials are already stored
  bool credentialsStored = prefs.getBool('credentialsStored') ?? false;
  if (!credentialsStored) {
    // Store default credentials
    prefs.setString('username', 'admin');
    prefs.setString('password', '123');
    
    // Set a flag to indicate that default credentials are stored
    prefs.setBool('credentialsStored', true);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fuel Station App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 47, 74, 150)),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
