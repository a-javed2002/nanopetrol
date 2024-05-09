import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserScreen extends StatefulWidget {
  final String companyId;

  const AddUserScreen({Key? key, required this.companyId}) : super(key: key);

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _addUser() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      // Show error message if name or email is empty
      return;
    }

    try {
      // Add user to Firestore users collection
      DocumentReference userRef =
          await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'email': email,
        // You may add other user details here
      });

      // Update company document to add user's UID to employeeIDs array
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(widget.companyId)
          .update({
        'employeeIDs': FieldValue.arrayUnion([userRef.id]),
      });

      // Clear text fields after adding user
      _nameController.clear();
      _emailController.clear();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User added successfully')),
      );
    } catch (error) {
      // Show error message if user addition fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add user: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addUser,
              child: const Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }
}
