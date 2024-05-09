import 'package:flutter/material.dart';
import 'package:petrol/views/card_screen.dart';
import 'package:petrol/views/cash_screen.dart';
import 'package:petrol/views/suspended_detail_screen.dart';
import 'package:petrol/views/suspended_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SalesScreen extends StatefulWidget {
  final String filling;
  final double price;
  final Map<String, dynamic>? sale;

  SalesScreen({Key? key, required this.filling, required this.price, this.sale})
      : super(key: key);

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  double? liters = 0;
  double totalPrice = 0;
  double grandTotalAmount = 0;

  // Future<bool> _addSaleToSharedPrefs({
  //   required double totalAmount,
  //   required double liter,
  //   required double price,
  // }) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   // Retrieve existing sales list or create a new one if not exist
  //   List<String> salesList = prefs.getStringList('salesList') ?? [];

  //   grandTotalAmount+=totalAmount;

  //   // Construct the sale information as a map
  //   Map<String, dynamic> saleInfo = {
  //     'fuel': [
  //       {
  //         'totalAmount': totalAmount.toString(),
  //         'price': price,
  //         'liter': liter,
  //         'filling': widget.filling,
  //       },
  //     ],
  //     'grandTotal':grandTotalAmount,
  //     'isSuspended':true,
  //     'pay': 0,
  //     'balance': 0,
  //     'received': 0,
  //     'paymentType': '',
  //     'timestamp': DateTime.now().toString(),
  //   };

  //   // Encode the sale information map to a JSON string
  //   String encodedSaleInfo = jsonEncode(saleInfo);

  //   // Add the encoded sale information to the list
  //   salesList.add(encodedSaleInfo);

  //   // Save the updated sales list
  //   await prefs.setStringList('salesList', salesList);

  //   return true;
  // }

  Future<bool> _addSaleToSharedPrefs({
    required double totalAmount,
    required double liter,
    required double price,
    Map<String, dynamic>? sale,
  }) async {
    sale = widget.sale;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve existing sales list or create a new one if not exist
    List<String> salesList = prefs.getStringList('salesList') ?? [];

    if (sale != null) {
      // If sale object is provided, find and update the previous sale
      int index = salesList.indexWhere((item) {
        Map<String, dynamic> decodedSale = jsonDecode(item);
        return decodedSale['timestamp'] == sale!['timestamp'];
      });

      if (index != -1) {
        // Update the fuel list object and overall details
        Map<String, dynamic> existingSale = jsonDecode(salesList[index]);
        List<Map<String, dynamic>> fuelList =
            List<Map<String, dynamic>>.from(existingSale['fuel']);

        // Update the fuel list object
        fuelList.add({
          'totalAmount': totalAmount.toString(),
          'price': price,
          'liter': liter,
          'filling': widget.filling,
        });

        // Update grand total amount
        double existingGrandTotal = existingSale['grandTotal'];
        double newGrandTotal = existingGrandTotal + totalAmount;

        // Update the sale information
        existingSale['fuel'] = fuelList;
        existingSale['grandTotal'] = newGrandTotal;

        // Encode the updated sale information
        String encodedSaleInfo = jsonEncode(existingSale);

        // Replace the existing sale with the updated sale in the list
        salesList[index] = encodedSaleInfo;

        // Save the updated sales list
        await prefs.setStringList('salesList', salesList);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuspendedSaleDetailScreen(
              sale: existingSale,
            ),
          ),
        );

        return true;
      }
    }

    // Construct the sale information as a map
    Map<String, dynamic> saleInfo = {
      'fuel': [
        {
          'totalAmount': totalAmount.toString(),
          'price': price,
          'liter': liter,
          'filling': widget.filling,
        },
      ],
      'grandTotal': totalAmount, // Initial grand total amount
      'isSuspended': true,
      'pay': 0,
      'balance': 0,
      'received': 0,
      'paymentType': '',
      'timestamp': DateTime.now().toString(),
    };

    // Encode the sale information map to a JSON string
    String encodedSaleInfo = jsonEncode(saleInfo);

    // Add the encoded sale information to the list
    salesList.add(encodedSaleInfo);

    // Save the updated sales list
    await prefs.setStringList('salesList', salesList);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SuspendedSalesScreen(),
      ),
    );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: const Color.fromARGB(255, 28, 137, 187),
          title: Text(
            widget.filling,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Liters'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    liters = double.tryParse(value);
                    if (liters != null) {
                      totalPrice = liters! * widget.price;
                      print(totalPrice);
                    } else {
                      totalPrice = 0;
                    }
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                initialValue: widget.price.toString(),
                enabled: false,
              ),
              SizedBox(height: 20),
              Text(
                'Total Amount: ${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.price == 0 || liters == 0) {
                          // Show snackbar with respective messages
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                widget.price == 0
                                    ? 'Price cannot be 0.'
                                    : 'Liters cannot be 0.',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CashPaymentScreen(
                                totalAmount: totalPrice,
                                liter: liters!,
                                price: widget.price,
                                filling: widget.filling,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Adjust the radius as needed
                        ),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16, // Adjust the font size as needed
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 24), // Adjust padding as needed
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Cash'), Icon(Icons.currency_exchange)],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.price == 0 || liters == 0) {
                          // Show snackbar with respective messages
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                widget.price == 0
                                    ? 'Price cannot be 0.'
                                    : 'Liters cannot be 0.',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CardPaymentScreen(
                                totalAmount: totalPrice,
                                liter: liters!,
                                price: widget.price,
                                filling: widget.filling,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Adjust the radius as needed
                        ),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16, // Adjust the font size as needed
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 24), // Adjust padding as needed
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Card'),
                          Icon(Icons.card_membership)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (widget.price == 0 || liters == 0) {
                          // Show snackbar with respective messages
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                widget.price == 0
                                    ? 'Price cannot be 0.'
                                    : 'Liters cannot be 0.',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
// Suspend the sale
                          await _addSaleToSharedPrefs(
                            totalAmount: totalPrice,
                            liter: liters ?? 0,
                            price: widget.price,
                          );

                          // Clear the form fields
                          setState(() {
                            liters = 0;
                            totalPrice = 0;
                          });

                          // Show snackbar indicating sale is suspended
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Sale suspended.',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Adjust the radius as needed
                        ),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16, // Adjust the font size as needed
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 24), // Adjust padding as needed
                      ),
                      child: Text('Suspend Sale'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
