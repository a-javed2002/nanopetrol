import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petrol/views/home_screen.dart';

class AddFuelScreen extends StatefulWidget {
  @override
  _AddFuelScreenState createState() => _AddFuelScreenState();
}

class _AddFuelScreenState extends State<AddFuelScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: const Color.fromARGB(255, 28, 137, 187),
          title: Text('Create New',
            style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        body: Container(
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     Color.fromARGB(
            //         255, 28, 137, 187), // Your specified background color
            //     Colors.white, // To transition smoothly to white
            //   ],
            // ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Enter name',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Enter Price',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveData,
                  child: Text('Save Data'),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Text('Show Saved Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = nameController.text;
    String price = priceController.text;
    String createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    String updatedAt = createdAt; // Initially, set updatedAt to createdAt

    // Retrieve existing list or create a new one if it doesn't exist
    List dataList = (prefs.getStringList('dataList') ?? [])
        .map((item) => json.decode(item))
        .toList();

    // Add new entry to the list
    dataList.add({
      'name': name,
      'price': price,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    });

    // Save the updated list back to SharedPreferences
    List<String> encodedDataList = dataList.map((item) => json.encode(item)).toList();
    await prefs.setStringList('dataList', encodedDataList);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Data Saved'),
          content: Text('name: $name\nprice: $price'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    // Clear the text fields after saving
    nameController.clear();
    priceController.clear();
  }
}
