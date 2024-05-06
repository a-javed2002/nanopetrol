import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClearDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 28, 137, 187),
          title: Text('Clear All Data',
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _clearDataList(context);
                  },
                  child: Text('Clear Data List'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _clearSalesList(context);
                  },
                  child: Text('Clear Sales List'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _clearDataList(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('dataList');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data list cleared'),
      ),
    );
  }

  Future<void> _clearSalesList(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('salesList');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sales list cleared'),
      ),
    );
  }
}
