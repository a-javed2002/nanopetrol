import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petrol/views/clear_screen.dart';

class DeleteFuelScreen extends StatefulWidget {
  @override
  _DeleteFuelScreenState createState() => _DeleteFuelScreenState();
}

class _DeleteFuelScreenState extends State<DeleteFuelScreen> {
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
          title: Text('Delete Each',
            style: TextStyle(fontWeight: FontWeight.bold),),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.movie_edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClearDataScreen()),
                );
              },
            ),
          ],
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
          child: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final data = dataList[index];
              return ListTile(
                title: Text('${data['name']}'),
                subtitle: Text('Price: ${data['price']}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteDialog(data);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(Map<String, dynamic> data) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Entry?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this entry?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteEntry(data);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEntry(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedDataList = prefs.getStringList('dataList') ?? [];
    List<Map<String, dynamic>> loadedDataList = encodedDataList
        .map<Map<String, dynamic>>((item) => json.decode(item))
        .toList();

    loadedDataList.remove(data);
    List<String> updatedEncodedDataList =
        loadedDataList.map((item) => json.encode(item)).toList();
    await prefs.setStringList('dataList', updatedEncodedDataList);

    setState(() {
      dataList = loadedDataList;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Entry deleted successfully.'),
      ),
    );
  }
}
