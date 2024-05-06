import 'package:flutter/material.dart';
import 'package:petrol/views/card_screen.dart';
import 'package:petrol/views/cash_screen.dart';

class SalesScreen extends StatefulWidget {
  final String filling;
  final double price;

  SalesScreen({Key? key, required this.filling, required this.price})
      : super(key: key);

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  double? liters = 0;
  double totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 28, 137, 187),
          title: Text(
            'Calculate Amount',
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
                              vertical: 12,
                              horizontal: 24), // Adjust padding as needed
                        ),
                        child: Text('Cash Payment'),
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
                              vertical: 12,
                              horizontal: 24), // Adjust padding as needed
                        ),
                        child: const Text('Card Payment'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
