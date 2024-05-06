import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petrol/views/home_screen.dart';

class CardPaymentScreen extends StatefulWidget {
  final double liter;
  final double price;
  final double totalAmount;
  final String filling;

  CardPaymentScreen(
      {Key? key,
      required this.filling,
      required this.liter,
      required this.price,
      required this.totalAmount})
      : super(key: key);

  @override
  _CardPaymentScreenState createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 28, 137, 187),
          title: Text(
            'Card Payment',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
                Text(
                  'Total Amount: ${widget.totalAmount}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Card Number'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Expiry Date'),
                  keyboardType: TextInputType.datetime,
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'CVV'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _addSaleToSharedPrefs();
                    Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                    // Process card payment
                  },
                  child: Text('Pay'),
                ),
              ],
            ),
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
      'liter': widget.liter,
      'pay': "",
      'received': "",
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
