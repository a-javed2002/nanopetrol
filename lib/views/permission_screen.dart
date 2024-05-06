import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PermissionHandlerExample(),
    );
  }
}

class PermissionHandlerExample extends StatefulWidget {
  @override
  _PermissionHandlerExampleState createState() => _PermissionHandlerExampleState();
}

class _PermissionHandlerExampleState extends State<PermissionHandlerExample> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission granted, proceed with your operations
    } else {
      // Permission denied, handle accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    // Your app UI
    return Scaffold(
      appBar: AppBar(
        title: Text('Permission Handler Example'),
      ),
      body: Center(
        child: Text('Requesting permissions...'),
      ),
    );
  }
}
