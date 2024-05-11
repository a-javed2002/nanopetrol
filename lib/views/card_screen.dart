import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petrol/views/home_screen.dart';

class CardPaymentScreen extends StatefulWidget {
  final Map<String, dynamic> sale;

  CardPaymentScreen({
    Key? key,
    required this.sale,
  }) : super(key: key);

  @override
  _CardPaymentScreenState createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  double cardPaymentAmount = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Card Payment',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Total Amount: ${widget.sale['grandTotal']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: cardNumberController,
                decoration: InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: expiryDateController,
                decoration: InputDecoration(labelText: 'Expiry Date'),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: cvvController,
                decoration: InputDecoration(labelText: 'CVV'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount Paying by Card'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    cardPaymentAmount = double.tryParse(value) ?? 0;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _addSaleToSharedPrefs(cardPaymentAmount);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text('Pay'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _addSaleToSharedPrefs(double cardPaymentAmount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> salesList = prefs.getStringList('salesList') ?? [];

    if (widget.sale != null) {
      int index = salesList.indexWhere((item) {
        Map<String, dynamic> decodedSale = jsonDecode(item);
        return decodedSale['timestamp'] == widget.sale['timestamp'];
      });

      if (index != -1) {
        Map<String, dynamic> existingSale = jsonDecode(salesList[index]);
        existingSale['payment'][0]['pay'] = cardPaymentAmount;
        existingSale['payment'][0]['balance'] = 0;
        existingSale['payment'][0]['received'] = 0;
        existingSale['payment'][0]['paymentType'] = 'Card';
        salesList[index] = jsonEncode(existingSale);

        await prefs.setStringList('salesList', salesList);

        return true;
      }
    }

    return false;
  }
}