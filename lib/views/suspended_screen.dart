import 'package:flutter/material.dart';
import 'package:petrol/views/suspended_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SuspendedSalesScreen extends StatefulWidget {
  @override
  _SuspendedSalesScreenState createState() => _SuspendedSalesScreenState();
}

class _SuspendedSalesScreenState extends State<SuspendedSalesScreen> {
  List<Map<String, dynamic>> suspendedSales = [];

  @override
  void initState() {
    super.initState();
    _getSuspendedSales();
  }

  Future<void> _getSuspendedSales() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? salesList = prefs.getStringList('salesList');

    if (salesList != null) {
      setState(() {
        suspendedSales = salesList
            .map((sale) => jsonDecode(sale) as Map<String, dynamic>)
            .where((sale) => sale['isSuspended'] == true)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suspended Sales'),
      ),
      body: suspendedSales.isEmpty
          ? Center(
              child: Text('No suspended sales'),
            )
          : ListView.builder(
              itemCount: suspendedSales.length,
              itemBuilder: (context, index) {
                final sale = suspendedSales[suspendedSales.length -
                    index -
                    1]; // Get the details of the last sale
                return Card.filled(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ListTile(
                    title: Text(
                        'Sale ${suspendedSales.length - index} (${sale['fuel'][0]['filling']})'), // Adjust the sale index accordingly
                    trailing: CircleAvatar(
                      maxRadius: 15,
                      backgroundColor: Colors.blue,
                      child: Text(
                        "${sale['fuel'].length}",
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),
                      ),
                    ),
                    subtitle: Text(
                        'Amount: ${sale['fuel'][0]['totalAmount']}, Liters: ${sale['fuel'][0]['liter']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SuspendedSaleDetailScreen(sale: sale),
                        ),
                      ).then((value) {
                        if (value != null && value) {
                          // Sale was deleted, refresh the list
                          _getSuspendedSales();
                        }
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}
