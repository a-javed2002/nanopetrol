import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petrol/firebase_options.dart';
import 'package:petrol/notifiers/theme.dart';
import 'package:petrol/views/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Fuel Station App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 47, 74, 150)),
//         useMaterial3: true,
//       ),
//       home: SplashScreen(),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
                seedColor: Colors.pink, brightness: Brightness.dark
                ),
            fontFamily: "Manrope",
            scaffoldBackgroundColor: themeProvider.currentTheme?.mainColor ?? Colors.blue,
            primaryColor: Colors.black,
            primaryColorLight: themeProvider.currentTheme?.lightColor ?? Colors.lightBlueAccent,
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
            home: SplashScreen(), // Your home page widget
          );
        },
      ),
    );
  }
}
