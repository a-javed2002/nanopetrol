import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PackageListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Package List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('packages').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final packages = snapshot.data!.docs;
          if (packages.isEmpty) {
            return Center(child: Text('No packages found'));
          }
          return ListView.builder(
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final packageData = packages[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(packageData['name']),
                subtitle: Text(packageData['description']),
                onTap: () {
                  // Navigate to package details screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PackageDetailsScreen(packageId: packages[index].id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class PackageDetailsScreen extends StatelessWidget {
  final String packageId;

  PackageDetailsScreen({required this.packageId});

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
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${packageData['name']}'),
                Text('Description: ${packageData['description']}'),
                Text('Duration: ${packageData['duration']}'),
                Text('Company IDs: ${packageData['companyIdArray'].join(', ')}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
