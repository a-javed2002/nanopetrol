import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petrol/views/dashboard_screen.dart';

class UpdateFuelScreen extends StatefulWidget {
  @override
  _UpdateFuelScreenState createState() => _UpdateFuelScreenState();
}

class _UpdateFuelScreenState extends State<UpdateFuelScreen> {
  List<Map<String, dynamic>> dataList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedDataList = prefs.getStringList('dataList') ?? [];
    List<Map<String, dynamic>> loadedDataList = encodedDataList
        .map<Map<String, dynamic>>((item) => json.decode(item))
        .toList();
    setState(() {
      dataList = loadedDataList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: const Color.fromARGB(255, 28, 137, 187),
          title: Text('Update Prices',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: dataList.map<Widget>((data) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${data['name']}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller:
                          TextEditingController(text: data['price'].toString()),
                      decoration: InputDecoration(
                        labelText: 'Enter Price',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        data['price'] = value;
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool x = await _saveData();
            if (x) {
              Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DashboardScreen()),
                    );
            }
          },
          child: Icon(Icons.save),
        ),
      ),
    );
  }

  Future<bool> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedDataList =
        dataList.map((item) => json.encode(item)).toList();
    await prefs.setStringList('dataList', encodedDataList);

    // Show a snackbar indicating that data has been updated
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fuel prices updated successfully.'),
      ),
    );

    return true;
  }
}
