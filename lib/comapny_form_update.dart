import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyUpdateScreen extends StatefulWidget {
  final String companyId;

  CompanyUpdateScreen({required this.companyId});

  @override
  _CompanyUpdateScreenState createState() => _CompanyUpdateScreenState();
}

class _CompanyUpdateScreenState extends State<CompanyUpdateScreen> {
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
  void initState() {
    super.initState();
    _fetchCompanyData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Company'),
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
              TextFormField(
                controller: _pricePetrolController,
                decoration: InputDecoration(labelText: 'Price for Petrol'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _priceDieselController,
                decoration: InputDecoration(labelText: 'Price for Diesel'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _priceLightDieselController,
                decoration: InputDecoration(labelText: 'Price for Light Diesel'),
                keyboardType: TextInputType.number,
              ),
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
                    _updateCompanyData();
                  }
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _fetchCompanyData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot documentSnapshot =
          await firestore.collection('companies').doc(widget.companyId).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        _nameController.text = data['name'] ?? '';
        _descriptionController.text = data['description'] ?? '';
        _pricePetrolController.text = data['prices']['Jan']['petrol'] ?? '';
        _priceDieselController.text = data['prices']['Jan']['diesel'] ?? '';
        _priceLightDieselController.text = data['prices']['Jan']['lightDiesel'] ?? '';
        _mainColorController.text = data['colors']['mainColor'] ?? '';
        _lightColorController.text = data['colors']['lightColor'] ?? '';
        _otherColorController.text = data['colors']['other'] ?? '';
        _logoController.text = data['images']['logo'] ?? '';
        _coverController.text = data['images']['cover'] ?? '';
        _employeeIdsController.text = (data['employeeIDs'] as List<dynamic> ?? []).join(', ');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch company data: $error')),
      );
    }
  }

  void _updateCompanyData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('companies').doc(widget.companyId).update({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'prices': {
          'Jan': {
            'petrol': _pricePetrolController.text,
            'diesel': _priceDieselController.text,
            'lightDiesel': _priceLightDieselController.text,
          },
        },
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Company data updated successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update company data: $error')),
      );
    }
  }
}