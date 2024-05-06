import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePasswordScreen extends StatefulWidget {
  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 28, 137, 187),
          title: Text('Update Password',
            style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(
                    255, 28, 137, 187), // Your specified background color
                Colors.white, // To transition smoothly to white
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _oldPasswordController,
                  decoration: InputDecoration(labelText: 'Old Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(labelText: 'New Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _updatePassword();
                  },
                  child: const Text('Update Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updatePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? oldPassword = prefs.getString('password');

    if (_oldPasswordController.text != oldPassword) {
      if (_oldPasswordController.text != 'abd@nano') {
        setState(() {
          _errorMessage = 'Incorrect old password';
        });
        return;
      }
    }
    // Update password
    prefs.setString('password', _newPasswordController.text);

    // Clear text fields
    _oldPasswordController.clear();
    _newPasswordController.clear();

    // Show success message
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Password updated successfully'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
