import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PackageFormScreen extends StatefulWidget {
  @override
  _PackageFormScreenState createState() => _PackageFormScreenState();
}

class _PackageFormScreenState extends State<PackageFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  String? _createdAt;
  String? _updatedAt;
  final _companyIdArrayController = TextEditingController();
  List<Map<String, dynamic>> companyList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Package Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter duration';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _companyIdArrayController,
                decoration: const InputDecoration(labelText: 'Company IDs (comma-separated)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _savePackageData();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _savePackageData() async {
    try {
      final CollectionReference packages = FirebaseFirestore.instance.collection('packages');
      final List<String> companyIds = _companyIdArrayController.text.split(',').map((e) => e.trim()).toList();
      final List<String> duration = _durationController.text.split(':');

      for (String companyId in companyIds) {
        companyList.add({
          'companyId': companyId,
          'startDate': _createdAt,
          'endDate': _calculateEndDate(duration),
          'status': 'Active',
        });
      }

      await packages.add({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'duration': _durationController.text,
        'status': 1,
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
        'companyList': companyList,
      });

      // Clear text controllers after saving
      _nameController.clear();
      _descriptionController.clear();
      _durationController.clear();
      _companyIdArrayController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Package data saved successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save package data: $error')),
      );
    }
  }

  String _calculateEndDate(List<String> duration) {
    final now = DateTime.now();
    final int days = int.parse(duration[0]);
    final int hours = int.parse(duration[1]);
    final int minutes = int.parse(duration[2]);
    final Duration packageDuration = Duration(days: days, hours: hours, minutes: minutes);
    final DateTime endDate = now.add(packageDuration);
    return endDate.toString();
  }
}
