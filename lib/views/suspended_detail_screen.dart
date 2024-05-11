import 'package:flutter/material.dart';
import 'package:petrol/views/card_screen.dart';
import 'package:petrol/views/cash_screen.dart';
import 'package:petrol/views/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SuspendedSaleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> sale;

  SuspendedSaleDetailScreen({Key? key, required this.sale}) : super(key: key);

  Future<void> _removeSale(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> salesList = prefs.getStringList('salesList') ?? [];
    salesList.removeWhere((sale) =>
        jsonDecode(sale)['isSuspended'] == true &&
        jsonDecode(sale)['timestamp'] == this.sale['timestamp']);
    await prefs.setStringList('salesList', salesList);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Suspended sale removed'),
      ),
    );
    Navigator.pop(context, true); // Indicate sale was deleted
  }

  Future<void> _removeFuelItem(BuildContext context, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> salesList = prefs.getStringList('salesList') ?? [];
    String saleTimestamp = sale['timestamp'];

    // Find the sale in the list
    int saleIndex = salesList.indexWhere((item) {
      Map<String, dynamic> decodedSale = jsonDecode(item);
      return decodedSale['isSuspended'] == true &&
          decodedSale['timestamp'] == saleTimestamp;
    });

    if (saleIndex != -1) {
      // Remove the specific fuel item from the sale
      List<Map<String, dynamic>> fuelList = List<Map<String, dynamic>>.from(
          jsonDecode(salesList[saleIndex])['fuel']);
      fuelList.removeAt(index);

      // Update the sale information
      Map<String, dynamic> updatedSale = jsonDecode(salesList[saleIndex]);
      updatedSale['fuel'] = fuelList;

      // Update the sales list
      salesList[saleIndex] = jsonEncode(updatedSale);

      // Save the updated sales list
      await prefs.setStringList('salesList', salesList);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fuel item removed from suspended sale'),
        ),
      );
      Navigator.pop(context, true); // Indicate fuel item was removed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suspended Sale Detail'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          sale: sale,
                        )),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: sale['fuel'].length, // Use the length of the 'fuel' list
          itemBuilder: (context, index) {
            var fuelItem = sale['fuel'][index];
            if (fuelItem['totalAmount'] == 0 || fuelItem['liter'] == 0) {
              return SizedBox.shrink(); // Skip items with zero values
            }
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Amount: ${fuelItem['totalAmount']}'),
                    Text('Liters: ${fuelItem['liter']}'),
                    Text('Filling: ${fuelItem['filling']}'),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    // _removeSale(context);
                    // _removeFuelItem(context, index);
                    _showConfirmationDialogItem(context,index);
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // _removeSale(context);
          _showConfirmationDialog(context);
        },
        child: const Icon(Icons.delete_forever),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(vertical: 12,horizontal: 6),
        child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CashPaymentScreen(
                                  sale: sale,
                                ),
                              ),
                            );
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
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => CardPaymentScreen(
                          //         totalAmount: totalPrice,
                          //         liter: liters!,
                          //         price: widget.price,
                          //         filling: widget.filling,
                          //       ),
                          //     ),
                          //   );
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
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this sale?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _removeSale(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialogItem(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this Fuel Item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _removeFuelItem(context, index);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
