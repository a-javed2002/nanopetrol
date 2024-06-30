// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:petrol/notifiers/theme.dart';
// import 'package:provider/provider.dart';
// import 'package:petrol/models/theme.dart';
// import 'package:petrol/views/splash_screen.dart';

// class LicenseVerificationScreen extends StatefulWidget {
//   @override
//   _LicenseVerificationScreenState createState() =>
//       _LicenseVerificationScreenState();
// }

// class _LicenseVerificationScreenState extends State<LicenseVerificationScreen> {
//   final TextEditingController _licenseKeyController = TextEditingController();

//   Future<void> _checkLicenseKey(BuildContext context) async {
//     String licenseKey = _licenseKeyController.text.trim();

//     try {
//       QuerySnapshot<Map<String, dynamic>> querySnapshot =
//           await FirebaseFirestore.instance
//               .collection('companies')
//               .where('licenseNumber', isEqualTo: licenseKey)
//               .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         // Company found, fetch and save details
//         var companyData = querySnapshot.docs.first.data();
//         // Save company details locally
//         Provider.of<CompanyThemeProvider>(context, listen: false)
//             .setCompanyDetails(
//           CompanyTheme(
//             name: companyData['name'],
//             description: companyData['description'],
//             mainColor: Color(int.parse(companyData['colors']['mainColor'])),
//             lightColor: Color(int.parse(companyData['colors']['lightColor'])),
//             otherColor: Color(int.parse(companyData['colors']['otherColor'])),
//             // Fetch and cache images
//             // logoUrl: await _cacheImage(companyData['images']['logo']),
//             // coverUrl: await _cacheImage(companyData['images']['cover']),
//             logoUrl: File(await _cacheImage(
//                 companyData['images']['logo'])), // Change String to File
//             coverUrl: File(await _cacheImage(companyData['images']['cover'])),
//             // Add additional company details here (name, description, etc.)
//           ),
//         );

//         // Navigate to next screen
//         // Navigator.pushReplacementNamed(
//         //     context, '/next_screen'); // Replace with your next screen route
//         Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => SplashScreen()),
//       );
//       } else {
//         // License key not found, show error message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Invalid license key!'),
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }
//     } catch (error) {
//       // Error handling
//       print('Error checking license key: $error');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error checking license key. Please try again later.'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   Future<String> _cacheImage(String imageUrl) async {
//     // Cache the image locally and return the cached file path
//     var file = await DefaultCacheManager().getSingleFile(imageUrl);
//     return file.path;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('License Verification'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _licenseKeyController,
//               decoration: InputDecoration(labelText: 'Enter License Key'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _checkLicenseKey(context),
//               child: Text('Verify License Key'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:petrol/notifiers/theme.dart';
import 'package:provider/provider.dart';
import 'package:petrol/models/theme.dart';
import 'package:petrol/views/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LicenseVerificationScreen extends StatefulWidget {
  @override
  _LicenseVerificationScreenState createState() =>
      _LicenseVerificationScreenState();
}

class _LicenseVerificationScreenState extends State<LicenseVerificationScreen> {
  final TextEditingController _licenseKeyController = TextEditingController(text: "rszc4bSKdmrbHvEddwsw");
  bool _isLoading = false; // State variable to track loading state

  Future<void> _checkLicenseKey(BuildContext context) async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    String licenseKey = _licenseKeyController.text.trim();

    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('companies')
              .doc(licenseKey) // Use licenseKey as the document ID
              .get();

      if (documentSnapshot.exists) {
        var companyData = documentSnapshot.data();
        print(
            'Fetched company data: $companyData'); // Print fetched data to console
        Provider.of<CompanyThemeProvider>(context, listen: false)
            .setCompanyDetails(
          CompanyTheme(
            name: companyData!['name'],
            description: companyData['description'],
            mainColor:
                Color(int.parse(companyData['colors']['mainColor'], radix: 16)),
            lightColor: Color(
                int.parse(companyData['colors']['lightColor'], radix: 16)),
            otherColor:
                Color(int.parse(companyData['colors']['other'], radix: 16)),
            logoUrl: File(await _cacheImage(
                companyData['images']['logo'])), // Change String to File
            coverUrl: File(await _cacheImage(companyData['images']['cover'])),
          ),
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLicense', true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Success!'),
            duration: Duration(seconds: 2),
          ),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SplashScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid license key!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      print('Error checking license key: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error checking license key. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false after completion
      });
    }
  }

  Future<String> _cacheImage(String imageUrl) async {
    try {
      var file = await DefaultCacheManager().getSingleFile(imageUrl);
      return file.path;
    } catch (e) {
      print('Error caching image: $e');
      return ""; // Or handle the error appropriately
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chk();
  }

  void chk() async {
    print("chking....");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var x = prefs.getBool('isLicense') ?? false;
    if (x) {
    print("chking....In");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('License Verification'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/backgorund.png'), // Replace with your image asset path
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30),
              Image.asset("assets/logo.png",width: 100,height: 100,),
              SizedBox(height: 60),
              TextField(
                controller: _licenseKeyController,
                decoration: InputDecoration(labelText: 'Enter License Key'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _checkLicenseKey(context),
                child: _isLoading
                    ? CircularProgressIndicator() // Show loader if loading
                    : Text('Verify License Key'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
