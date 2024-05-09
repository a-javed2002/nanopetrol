import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petrol/views/home_screen.dart';

class CashPaymentScreen extends StatefulWidget {
  final double liter;
  final double price;
  final double totalAmount;
  final String filling;

  CashPaymentScreen(
      {Key? key,
      required this.filling,
      required this.liter,
      required this.price,
      required this.totalAmount})
      : super(key: key);

  @override
  _CashPaymentScreenState createState() => _CashPaymentScreenState();
}

class _CashPaymentScreenState extends State<CashPaymentScreen> {
  double cashInput = 0;
  double remainingAmount = 0;

  @override
  Widget build(BuildContext context) {
    remainingAmount =
        (widget.totalAmount - (cashInput ?? 0)).abs(); // Taking modulus

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Cash Payment',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Total Amount: ${widget.totalAmount}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cash Input'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    cashInput = double.tryParse(value) ?? 0;
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                'Remaining Amount: $remainingAmount',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (cashInput >= widget.totalAmount) {
                    bool x = await _addSaleToSharedPrefs();
                    if (x) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Input Cash Amount',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text('Pay'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _addSaleToSharedPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieve existing sales list or create a new one if not exist
  List<String> salesList = prefs.getStringList('salesList') ?? [];

  // Construct the sale information as a map
  Map<String, dynamic> saleInfo = {
    'totalAmount': widget.totalAmount.toString(),
    'price': widget.price,
    'filling': widget.filling,
    'liter': widget.liter,
    'pay': cashInput,
    'received': remainingAmount,
    'paymentType': 'Cash',
    'timestamp': DateTime.now().toString(),
  };

  // Encode the sale information map to a JSON string
  String encodedSaleInfo = jsonEncode(saleInfo);

  // Add the encoded sale information to the list
  salesList.add(encodedSaleInfo);

  // Save the updated sales list
  await prefs.setStringList('salesList', salesList);

  return true;
}
}
