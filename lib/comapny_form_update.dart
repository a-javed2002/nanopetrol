// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class CompanyUpdateScreen extends StatefulWidget {
//   final String companyId;

//   CompanyUpdateScreen({required this.companyId});

//   @override
//   _CompanyUpdateScreenState createState() => _CompanyUpdateScreenState();
// }

// class _CompanyUpdateScreenState extends State<CompanyUpdateScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   // final _pricePetrolController = TextEditingController();
//   // final _priceDieselController = TextEditingController();
//   // final _priceLightDieselController = TextEditingController();
//   final _mainColorController = TextEditingController();
//   final _lightColorController = TextEditingController();
//   final _otherColorController = TextEditingController();
//   final _logoController = TextEditingController();
//   final _coverController = TextEditingController();
//   final _employeeIdsController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchCompanyData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Update Company'),
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
//                     _updateCompanyData();
//                   }
//                 },
//                 child: Text('Update'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _fetchCompanyData() async {
//     try {
//       FirebaseFirestore firestore = FirebaseFirestore.instance;
//       DocumentSnapshot documentSnapshot =
//           await firestore.collection('companies').doc(widget.companyId).get();
//       if (documentSnapshot.exists) {
//         Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
//         _nameController.text = data['name'] ?? '';
//         _descriptionController.text = data['description'] ?? '';
//         // _pricePetrolController.text = data['prices']['Jan']['petrol'] ?? '';
//         // _priceDieselController.text = data['prices']['Jan']['diesel'] ?? '';
//         // _priceLightDieselController.text = data['prices']['Jan']['lightDiesel'] ?? '';
//         _mainColorController.text = data['colors']['mainColor'] ?? '';
//         _lightColorController.text = data['colors']['lightColor'] ?? '';
//         _otherColorController.text = data['colors']['other'] ?? '';
//         _logoController.text = data['images']['logo'] ?? '';
//         _coverController.text = data['images']['cover'] ?? '';
//         _employeeIdsController.text = (data['employeeIDs'] as List<dynamic> ?? []).join(', ');
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to fetch company data: $error')),
//       );
//     }
//   }

//   void _updateCompanyData() async {
//     try {
//       FirebaseFirestore firestore = FirebaseFirestore.instance;
//       await firestore.collection('companies').doc(widget.companyId).update({
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
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Company data updated successfully')),
//       );
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update company data: $error')),
//       );
//     }
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'dart:io';
// import 'dart:html' as html;
// import 'dart:convert';

import 'package:petrol/company.dart';

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
  final _mainColorController = TextEditingController();
  final _lightColorController = TextEditingController();
  final _otherColorController = TextEditingController();
  final _employeeIdsController = TextEditingController();

  late String _logoUrl = "";
  late String _coverUrl = "";
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchCompanyData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Company'),
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
              const SizedBox(height: 20),
              // Display logo image
              _logoUrl.isNotEmpty
                  ? Image.network(
                      _logoUrl,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        // If an error occurs while fetching the image, display a fallback image from assets
                        return Image.asset(
                          'assets/no-image.jpg', // Provide the path to the fallback image in the assets folder
                          width: 200, // Adjust width and height as needed
                          height: 200,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/no-image.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
              // Button to upload or change logo image
              ElevatedButton(
                onPressed: () => _uploadImage('logo', 'uploads'),
                child: const Text('Upload or Change Logo'),
              ),
              const SizedBox(height: 20),
              // Display cover image
              _coverUrl.isNotEmpty
                  ? Image.network(
                      _coverUrl,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        // If an error occurs while fetching the image, display a fallback image from assets
                        return Image.asset(
                          'assets/no-image.jpg', // Provide the path to the fallback image in the assets folder
                          width: 200, // Adjust width and height as needed
                          height: 200,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/no-image.jpg',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
              // Button to upload or change cover image
              ElevatedButton(
                onPressed: () => _uploadImage('cover', 'uploads'),
                child: const Text('Upload or Change Cover Image'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _employeeIdsController,
                decoration: const InputDecoration(
                    labelText: 'Employee IDs (comma-separated)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateCompanyData();
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _fetchCompanyData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('companies')
          .doc(widget.companyId)
          .get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _descriptionController.text = data['description'] ?? '';
          _mainColorController.text = data['colors']['mainColor'] ?? '';
          _lightColorController.text = data['colors']['lightColor'] ?? '';
          _otherColorController.text = data['colors']['other'] ?? '';
          _logoUrl = data['images']['logo'] ?? '';
          _coverUrl = data['images']['cover'] ?? '';
          _employeeIdsController.text =
              (data['employeeIDs'] as List<dynamic> ?? []).join(', ');
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch company data: $error')),
      );
    }
  }

  void _updateCompanyData() async {
    try {
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(widget.companyId)
          .update({
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
        'employeeIDs': _employeeIdsController.text
            .split(',')
            .map((e) => e.trim())
            .toList(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Company data updated successfully')),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CompanyListScreen()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update company data: $error')),
      );
    }
  }

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
      //           var storageRef = firebase_storage.FirebaseStorage.instance.ref(
      //               '$folderName/${DateTime.now().millisecondsSinceEpoch}');
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
          var storageRef = firebase_storage.FirebaseStorage.instance
              .ref('$folderName/$fileName');
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
}
