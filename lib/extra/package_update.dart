import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PackageUpdateScreen extends StatefulWidget {
  final String packageId;

  PackageUpdateScreen({required this.packageId});

  @override
  _PackageUpdateScreenState createState() => _PackageUpdateScreenState();
}

class _PackageUpdateScreenState extends State<PackageUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _companyIdArrayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Package'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('packages').doc(widget.packageId).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData) {
                return Text('Package not found');
              }
              final packageData = snapshot.data!;
              _nameController.text = packageData['name'];
              _descriptionController.text = packageData['description'];
              _durationController.text = packageData['duration'];
              _companyIdArrayController.text = packageData['companyIdArray'].join(', ');

              return ListView(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _durationController,
                    decoration: InputDecoration(labelText: 'Duration'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter duration';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _companyIdArrayController,
                    decoration: InputDecoration(labelText: 'Company IDs (comma-separated)'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _updatePackageData();
                      }
                    },
                    child: Text('Update'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _updatePackageData() async {
    try {
      final CollectionReference packages = FirebaseFirestore.instance.collection('packages');
      await packages.doc(widget.packageId).update({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'duration': _durationController.text,
        'companyIdArray': _companyIdArrayController.text.split(',').map((e) => e.trim()).toList(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Package data updated successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update package data: $error')),
      );
    }
  }
}
