import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyFormScreen extends StatefulWidget {
  @override
  _CompanyFormScreenState createState() => _CompanyFormScreenState();
}

class _CompanyFormScreenState extends State<CompanyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pricePetrolController = TextEditingController();
  final _priceDieselController = TextEditingController();
  final _priceLightDieselController = TextEditingController();
  final _mainColorController = TextEditingController();
  final _lightColorController = TextEditingController();
  final _otherColorController = TextEditingController();
  final _logoController = TextEditingController();
  final _coverController = TextEditingController();
  final _employeeIdsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
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
              // TextFormField(
              //   controller: _pricePetrolController,
              //   decoration: InputDecoration(labelText: 'Price for Petrol'),
              //   keyboardType: TextInputType.number,
              // ),
              // TextFormField(
              //   controller: _priceDieselController,
              //   decoration: InputDecoration(labelText: 'Price for Diesel'),
              //   keyboardType: TextInputType.number,
              // ),
              // TextFormField(
              //   controller: _priceLightDieselController,
              //   decoration: InputDecoration(labelText: 'Price for Light Diesel'),
              //   keyboardType: TextInputType.number,
              // ),
              TextFormField(
                controller: _mainColorController,
                decoration: InputDecoration(labelText: 'Main Color'),
              ),
              TextFormField(
                controller: _lightColorController,
                decoration: InputDecoration(labelText: 'Light Color'),
              ),
              TextFormField(
                controller: _otherColorController,
                decoration: InputDecoration(labelText: 'Other Color'),
              ),
              TextFormField(
                controller: _logoController,
                decoration: InputDecoration(labelText: 'Logo URL'),
              ),
              TextFormField(
                controller: _coverController,
                decoration: InputDecoration(labelText: 'Cover URL'),
              ),
              TextFormField(
                controller: _employeeIdsController,
                decoration: InputDecoration(labelText: 'Employee IDs (comma-separated)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveCompanyData();
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveCompanyData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('companies').add({
        'name': _nameController.text,
        'description': _descriptionController.text,
        // 'prices': {
        //   'Jan': {
        //     'petrol': _pricePetrolController.text,
        //     'diesel': _priceDieselController.text,
        //     'lightDiesel': _priceLightDieselController.text,
        //   },
        // },
        'colors': {
          'mainColor': _mainColorController.text,
          'lightColor': _lightColorController.text,
          'other': _otherColorController.text,
        },
        'images': {
          'logo': _logoController.text,
          'cover': _coverController.text,
        },
        'employeeIDs': _employeeIdsController.text.split(',').map((e) => e.trim()).toList(),
      });
      // Clear text controllers after saving
      _nameController.clear();
      _descriptionController.clear();
      _pricePetrolController.clear();
      _priceDieselController.clear();
      _priceLightDieselController.clear();
      _mainColorController.clear();
      _lightColorController.clear();
      _otherColorController.clear();
      _logoController.clear();
      _coverController.clear();
      _employeeIdsController.clear();
      // Show success message or navigate to another screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Company data saved successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save company data: $error')),
      );
    }
  }
}

