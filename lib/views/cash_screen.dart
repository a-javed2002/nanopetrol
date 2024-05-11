import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petrol/views/home_screen.dart';

class CashPaymentScreen extends StatefulWidget {
  final Map<String, dynamic>? sale;

  CashPaymentScreen({
    Key? key,
    this.sale,
  }) : super(key: key);

  @override
  _CashPaymentScreenState createState() => _CashPaymentScreenState();
}

class _CashPaymentScreenState extends State<CashPaymentScreen> {
  double cashInput = 0;
  double totalPaid = 0;
  double remainingAmount = 0;
  double returnAmount = 0;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    remainingAmount = (widget.sale!['grandTotal'] - totalPaid).abs();
    returnAmount = cashInput > widget.sale!['grandTotal']
        ? cashInput - widget.sale!['grandTotal']
        : 0;
  }

  @override
  Widget build(BuildContext context) {
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
              // Display fuels present in the sale
              if (widget.sale != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fuels:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Column(
                      children: (widget.sale!['fuel'] as List).map((fuel) {
                        return ListTile(
                          title: Text('Amount: ${fuel['totalAmount']}'),
                          subtitle: Text(
                              'Price: ${fuel['price']}, Liter: ${fuel['liter']}, Filling: ${fuel['filling']}'),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              Text(
                'Total Amount: ${widget.sale!['grandTotal']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Total Paid: $totalPaid',
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
              Text(
                'Return Amount: $returnAmount',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (totalPaid < widget.sale!['grandTotal']) {
                    // Add current cash input to total paid
                    setState(() {
                      totalPaid += cashInput;
                    });
                  }

                  if (totalPaid >= widget.sale!['grandTotal']) {
                    bool x = await _addSaleToSharedPrefs();
                    if (x) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
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

    if (widget.sale != null) {
      // If sale object is provided, find and update the previous sale
      int index = salesList.indexWhere((item) {
        Map<String, dynamic> decodedSale = jsonDecode(item);
        return decodedSale['timestamp'] == widget.sale!['timestamp'];
      });

      if (index != -1) {
        // Update the existing sale with the new payment details
        Map<String, dynamic> existingSale = jsonDecode(salesList[index]);
        existingSale['payment'][0]['pay'] = totalPaid;
        existingSale['payment'][0]['balance'] = 0;
        existingSale['payment'][0]['received'] = returnAmount;
        existingSale['payment'][0]['paymentType'] =
            'Cash'; // Update payment type accordingly
        salesList[index] = jsonEncode(existingSale);

        // Save the updated sales list
        await prefs.setStringList('salesList', salesList);

        return true;
      }
    }

    return false; // Return false if sale is not found or cannot be updated
  }
}
