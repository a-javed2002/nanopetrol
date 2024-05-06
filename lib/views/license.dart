import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:petrol/notifiers/theme.dart';
import 'package:provider/provider.dart';
import 'package:petrol/models/theme.dart';

class LicenseVerificationScreen extends StatefulWidget {
  @override
  _LicenseVerificationScreenState createState() =>
      _LicenseVerificationScreenState();
}

class _LicenseVerificationScreenState extends State<LicenseVerificationScreen> {
  final TextEditingController _licenseKeyController = TextEditingController();

  Future<void> _checkLicenseKey(BuildContext context) async {
    String licenseKey = _licenseKeyController.text.trim();

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('companies')
              .where('licenseNumber', isEqualTo: licenseKey)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Company found, fetch and save details
        var companyData = querySnapshot.docs.first.data();
        // Save company details locally
        Provider.of<CompanyThemeProvider>(context, listen: false)
            .setCompanyDetails(
          CompanyTheme(
            name: companyData['name'],
            description: companyData['description'],
            mainColor: Color(int.parse(companyData['colors']['mainColor'])),
            lightColor: Color(int.parse(companyData['colors']['lightColor'])),
            otherColor: Color(int.parse(companyData['colors']['otherColor'])),
            // Fetch and cache images
            // logoUrl: await _cacheImage(companyData['images']['logo']),
            // coverUrl: await _cacheImage(companyData['images']['cover']),
            logoUrl: File(await _cacheImage(
                companyData['images']['logo'])), // Change String to File
            coverUrl: File(await _cacheImage(companyData['images']['cover'])),
            // Add additional company details here (name, description, etc.)
          ),
        );

        // Navigate to next screen
        Navigator.pushReplacementNamed(
            context, '/next_screen'); // Replace with your next screen route
      } else {
        // License key not found, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid license key!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      // Error handling
      print('Error checking license key: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error checking license key. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<String> _cacheImage(String imageUrl) async {
    // Cache the image locally and return the cached file path
    var file = await DefaultCacheManager().getSingleFile(imageUrl);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('License Verification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _licenseKeyController,
              decoration: InputDecoration(labelText: 'Enter License Key'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _checkLicenseKey(context),
              child: Text('Verify License Key'),
            ),
          ],
        ),
      ),
    );
  }
}
