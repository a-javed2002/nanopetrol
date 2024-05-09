// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class CompanyFormScreen extends StatefulWidget {
//   @override
//   _CompanyFormScreenState createState() => _CompanyFormScreenState();
// }

// class _CompanyFormScreenState extends State<CompanyFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _pricePetrolController = TextEditingController();
//   final _priceDieselController = TextEditingController();
//   final _priceLightDieselController = TextEditingController();
//   final _mainColorController = TextEditingController();
//   final _lightColorController = TextEditingController();
//   final _otherColorController = TextEditingController();
//   final _logoController = TextEditingController();
//   final _coverController = TextEditingController();
//   final _employeeIdsController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Company Form'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: 'Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(labelText: 'Description'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a description';
//                   }
//                   return null;
//                 },
//               ),
//               // TextFormField(
//               //   controller: _pricePetrolController,
//               //   decoration: InputDecoration(labelText: 'Price for Petrol'),
//               //   keyboardType: TextInputType.number,
//               // ),
//               // TextFormField(
//               //   controller: _priceDieselController,
//               //   decoration: InputDecoration(labelText: 'Price for Diesel'),
//               //   keyboardType: TextInputType.number,
//               // ),
//               // TextFormField(
//               //   controller: _priceLightDieselController,
//               //   decoration: InputDecoration(labelText: 'Price for Light Diesel'),
//               //   keyboardType: TextInputType.number,
//               // ),
//               TextFormField(
//                 controller: _mainColorController,
//                 decoration: InputDecoration(labelText: 'Main Color'),
//               ),
//               TextFormField(
//                 controller: _lightColorController,
//                 decoration: InputDecoration(labelText: 'Light Color'),
//               ),
//               TextFormField(
//                 controller: _otherColorController,
//                 decoration: InputDecoration(labelText: 'Other Color'),
//               ),
//               TextFormField(
//                 controller: _logoController,
//                 decoration: InputDecoration(labelText: 'Logo URL'),
//               ),
//               TextFormField(
//                 controller: _coverController,
//                 decoration: InputDecoration(labelText: 'Cover URL'),
//               ),
//               TextFormField(
//                 controller: _employeeIdsController,
//                 decoration: InputDecoration(labelText: 'Employee IDs (comma-separated)'),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     _saveCompanyData();
//                   }
//                 },
//                 child: Text('Save'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _saveCompanyData() async {
//     try {
//       FirebaseFirestore firestore = FirebaseFirestore.instance;
//       await firestore.collection('companies').add({
//         'name': _nameController.text,
//         'description': _descriptionController.text,
//         // 'prices': {
//         //   'Jan': {
//         //     'petrol': _pricePetrolController.text,
//         //     'diesel': _priceDieselController.text,
//         //     'lightDiesel': _priceLightDieselController.text,
//         //   },
//         // },
//         'colors': {
//           'mainColor': _mainColorController.text,
//           'lightColor': _lightColorController.text,
//           'other': _otherColorController.text,
//         },
//         'images': {
//           'logo': _logoController.text,
//           'cover': _coverController.text,
//         },
//         'employeeIDs': _employeeIdsController.text.split(',').map((e) => e.trim()).toList(),
//       });
//       // Clear text controllers after saving
//       _nameController.clear();
//       _descriptionController.clear();
//       _pricePetrolController.clear();
//       _priceDieselController.clear();
//       _priceLightDieselController.clear();
//       _mainColorController.clear();
//       _lightColorController.clear();
//       _otherColorController.clear();
//       _logoController.clear();
//       _coverController.clear();
//       _employeeIdsController.clear();
//       // Show success message or navigate to another screen
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Company data saved successfully')),
//       );
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to save company data: $error')),
//       );
//     }
//   }
// }




import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
// import 'dart:html' as html;
// import 'dart:convert';

import 'package:petrol/company.dart';

class CompanyFormScreen extends StatefulWidget {
  const CompanyFormScreen({super.key});

  @override
  _CompanyFormScreenState createState() => _CompanyFormScreenState();
}

class _CompanyFormScreenState extends State<CompanyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _mainColorController = TextEditingController();
  final _lightColorController = TextEditingController();
  final _otherColorController = TextEditingController();
  String? _logoUrl; // Store the download URL of the logo
  String? _coverUrl; // Store the download URL of the cover image
  final _employeeIdsController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

Future<void> _uploadImage(String imagePath, String folderName) async {
  if (kIsWeb) {
    // // Web specific code for image picking
    // html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    // uploadInput.click();

    // uploadInput.onChange.listen((e) {
    //   if (uploadInput.files!.isNotEmpty) {
    //     final file = uploadInput.files!.first;
    //     final reader = html.FileReader();
    //     reader.readAsDataUrl(file);
    //     reader.onLoadEnd.listen((e) async {
    //       final encodedImage = reader.result as String?;
    //       if (encodedImage != null) {
    //         final bytes = base64.decode(encodedImage.split(',').last);
    //         final blob = html.Blob([bytes]);
    //         final url = html.Url.createObjectUrlFromBlob(blob);

    //         try {
    //           var storageRef = firebase_storage.FirebaseStorage.instance.ref('$folderName/${DateTime.now().millisecondsSinceEpoch}');
    //           await storageRef.putBlob(blob);

    //           String downloadURL = await storageRef.getDownloadURL();
    //           setState(() {
    //             if (imagePath == 'logo') {
    //               _logoUrl = downloadURL;
    //             } else if (imagePath == 'cover') {
    //               _coverUrl = downloadURL;
    //             }
    //           });

    //           ScaffoldMessenger.of(context).showSnackBar(
    //             SnackBar(content: Text('Image uploaded successfully')),
    //           );
    //         } catch (error) {
    //           ScaffoldMessenger.of(context).showSnackBar(
    //             SnackBar(content: Text('Failed to upload image: $error')),
    //           );
    //         }
    //       }
    //     });
    //   }
    // });
  } else if (Platform.isAndroid || Platform.isIOS) {
    // Android and iOS specific code for image picking
    final pickerImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickerImage != null) {
      File file = File(pickerImage.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      try {
        var storageRef = firebase_storage.FirebaseStorage.instance.ref('$folderName/$fileName');
        await storageRef.putFile(file);

        String downloadURL = await storageRef.getDownloadURL();
        setState(() {
          if (imagePath == 'logo') {
            _logoUrl = downloadURL;
          } else if (imagePath == 'cover') {
            _coverUrl = downloadURL;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $error')),
        );
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Form'),
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
                controller: _mainColorController,
                decoration: const InputDecoration(labelText: 'Main Color'),
              ),
              TextFormField(
                controller: _lightColorController,
                decoration: const InputDecoration(labelText: 'Light Color'),
              ),
              TextFormField(
                controller: _otherColorController,
                decoration: const InputDecoration(labelText: 'Other Color'),
              ),
              TextFormField(
                controller: _employeeIdsController,
                decoration: const InputDecoration(labelText: 'Employee IDs (comma-separated)'),
              ),
              const SizedBox(height: 20),

              // Button to upload logo image
              ElevatedButton(
                onPressed: () => _uploadImage('logo', 'uploads'),
                child: const Text('Upload Logo'),
              ),

              // Button to upload cover image
              ElevatedButton(
                onPressed: () => _uploadImage('cover', 'uploads'),
                child: const Text('Upload Cover Image'),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _logoUrl != null &&
                      _coverUrl != null) {
                    _saveCompanyData();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload logo and cover image')),
                    );
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

  void _saveCompanyData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('companies').add({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'colors': {
          'mainColor': _mainColorController.text,
          'lightColor': _lightColorController.text,
          'other': _otherColorController.text,
        },
        'images': {
          'logo': _logoUrl,
          'cover': _coverUrl,
        },
        'employeeIDs': _employeeIdsController.text.split(',').map((e) => e.trim()).toList(),
      });
      // Clear text controllers after saving
      _nameController.clear();
      _descriptionController.clear();
      _mainColorController.clear();
      _lightColorController.clear();
      _otherColorController.clear();
      _employeeIdsController.clear();
      // Show success message or navigate to another screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Company data saved successfully')),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CompanyListScreen()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save company data: $error')),
      );
    }
  }
}
