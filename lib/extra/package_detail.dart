import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PackageDetailScreen extends StatelessWidget {
  final String packageId;

  PackageDetailScreen({required this.packageId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Package Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('packages').doc(packageId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('Package not found'));
          }
          final packageData = snapshot.data!.data() as Map<String, dynamic>;
          final List<dynamic> companyList = packageData['companyList'];

          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${packageData['name']}'),
                Text('Description: ${packageData['description']}'),
                Text('Duration: ${packageData['duration']}'),
                Text('Company Details:'),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: companyList.length,
                    itemBuilder: (context, index) {
                      final company = companyList[index];
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('companies').doc(company['companyId']).get(),
                        builder: (context, companySnapshot) {
                          if (companySnapshot.connectionState == ConnectionState.waiting) {
                            return SizedBox(); // Return an empty SizedBox while loading
                          }
                          if (companySnapshot.hasError) {
                            return Text('Error: ${companySnapshot.error}');
                          }
                          if (!companySnapshot.hasData) {
                            return SizedBox(); // Return an empty SizedBox if company data not found
                          }
                          final companyData = companySnapshot.data!.data() as Map<String, dynamic>;
                          final String logoUrl = companyData['logoUrl']; // Assuming 'logoUrl' is the field storing logo URL
                          return GestureDetector(
                            onTap: () {
                              _showCompanyDetails(context, companyData);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  logoUrl,
                                  height: 50, // Adjust height as needed
                                  width: 50, // Adjust width as needed
                                  fit: BoxFit.cover, // Ensure the logo fits properly
                                ),
                                Text('Company ID: ${company['companyId']}'),
                                Text('Start Time: ${company['startDate']}'),
                                Text('End Time: ${company['endDate']}'),
                                Text('Status: ${company['status']}'),
                                SizedBox(height: 10),
                                Divider(), // Adds a divider between company details
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCompanyDetails(BuildContext context, Map<String, dynamic> companyData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Company Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: ${companyData['name']}'),
              Text('Address: ${companyData['address']}'),
              Text('Description: ${companyData['description']}'),
              // Add more details here as needed
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
