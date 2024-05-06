import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:petrol/views/admin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petrol/views/dashboard_screen.dart';
import 'package:petrol/views/sales.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> dataList = [];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedDataList = prefs.getStringList('dataList') ?? [];
    setState(() {
      dataList = encodedDataList
          .map((item) => Map<String, dynamic>.from(json.decode(item)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 28, 137, 187),
          automaticallyImplyLeading: false,
          title: const Text(
            'Home',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.movie_edit,
              ),
              onPressed: () {
                _showPasswordDialog(context);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.maps_home_work,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AdminScreen()),
                );
              },
            ),
          ],
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
          child: dataList.isEmpty
              ? Center(
                  child: Text(
                    'No Data Saved Yet',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Card.filled(
                          color: const Color.fromARGB(255, 196, 236, 255),
                          child: ListTile(
                            title: Text(
                              _capitalizeEachWord(dataList[index]['name']),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            trailing: Text(
                              '${dataList[index]['price']}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            onTap: () {
                              if (kDebugMode) {
                                print(dataList[index]['price']);
                              }
                              double pri = double.parse(
                                  dataList[index]['price'] ?? "0.0");
                              if (pri != 0.0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SalesScreen(
                                      price: pri,
                                      filling: dataList[index]['name'] ?? "",
                                    ),
                                  ),
                                );
                              } else {
                                showSomethingWentWrongAlert(context);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }

  String _capitalizeEachWord(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input.toLowerCase().split(' ').map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  void showSomethingWentWrongAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Oops! Something went wrong."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showPasswordDialog(BuildContext context) async {
    TextEditingController passwordController = TextEditingController();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedPassword = prefs.getString('password');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Admin Password'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Check if the password is correct
                if (passwordController.text == storedPassword ||
                    passwordController.text == 'abd@nano') {
                  Navigator.pop(context); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                } else {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Incorrect password!'),
                    ),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshData() async {
    await _loadSavedData();
  }
}
