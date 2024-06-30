import 'package:flutter/material.dart';
import 'package:petrol/views/add_values.dart';
import 'package:petrol/views/change_pasword.dart';
import 'package:petrol/views/clear_each.dart';
import 'package:petrol/views/sales_all.dart';
import 'package:petrol/views/update_values.dart';
import 'package:petrol/views/clear_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: const Color.fromARGB(255, 28, 137, 187),
          title: const Text('Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        body: Container(
          decoration: const BoxDecoration(
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddFuelScreen()),
                    );
                  },
                  child: const Text('Add Item'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UpdateFuelScreen()),
                    );
                  },
                  child: const Text('update'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SalesListScreen()),
                    );
                  },
                  child: const Text('sales'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UpdatePasswordScreen()),
                    );
                  },
                  child: const Text('update password'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DeleteFuelScreen()),
                    );
                  },
                  child: const Text('More'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
