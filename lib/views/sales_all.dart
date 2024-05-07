import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petrol/views/salesDetail.dart';

class SalesListScreen extends StatefulWidget {
  @override
  _SalesListScreenState createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  List<Map<String, dynamic>> salesList = [];

  @override
  void initState() {
    super.initState();
    _loadSalesList();
  }

  Future<void> _loadSalesList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedSalesList = prefs.getStringList('salesList') ?? [];
    List<Map<String, dynamic>> decodedSalesList =
        savedSalesList.map<Map<String, dynamic>>((sale) {
      return jsonDecode(sale);
    }).toList();
    setState(() {
      salesList = decodedSalesList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: const Color.fromARGB(255, 28, 137, 187),
          title: Text(
            'Sales List',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
          child: salesList.isEmpty
              ? Center(
                  child: Text(
                    'No Sales Yet',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : ListView.builder(
                  itemCount: salesList.length,
                  itemBuilder: (context, index) {
                    DateTime timestamp =
                        DateTime.parse(salesList[index]['timestamp']);

                    // Format date and time separately
                    String date = DateFormat('yyyy-MM-dd').format(timestamp);
                    String time = DateFormat('HH:mm:ss').format(timestamp);
                    return Card.filled(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: ListTile(
                          title: Text(
                              'Amount: ${salesList[index]['totalAmount']}'),
                          subtitle:
                              Text('Type: ${salesList[index]['paymentType']}'),
                          trailing: Text(date),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SalesDetailScreen(
                                  saleData: salesList[index],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
