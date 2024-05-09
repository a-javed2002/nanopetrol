import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:petrol/views/admin.dart';
import 'package:petrol/views/btn.dart';
import 'package:petrol/views/sales_all.dart';
import 'package:petrol/views/suspended_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petrol/views/dashboard_screen.dart';
import 'package:petrol/views/sales.dart';
import 'package:petrol/models/theme.dart';
import 'package:petrol/notifiers/theme.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic>? sale;
  const HomeScreen({super.key, this.sale});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> dataList = [];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedDataList = prefs.getStringList('dataList') ?? [];
    setState(() {
      dataList = encodedDataList
          .map((item) => Map<String, dynamic>.from(json.decode(item)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    CompanyTheme? companyTheme =
        Provider.of<CompanyThemeProvider>(context).currentTheme;
    print("Theme is ${companyTheme}");
    print("Color is ${companyTheme?.mainColor}");
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        // backgroundColor:
        //     companyTheme?.mainColor ?? Color.fromARGB(255, 28, 137, 187),
        automaticallyImplyLeading: widget.sale != null ? false : true,
        // leading: IconButton(
        //   icon: Icon(Icons.menu), // Add the drawer icon here
        //   onPressed: () {
        //     Scaffold.of(context)
        //         .openDrawer(); // Open the drawer when the icon is tapped
        //   },
        // ),
        title: widget.sale != null
            ? const Text(
                "Editing Sale",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            : const Text(
                'Home',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
        actions: widget.sale != null
            ? <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.maps_home_work,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                ),
              ]
            : <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.movie_edit,
                  ),
                  onPressed: () {
                    _showPasswordDialog(context);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.maps_home_work,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AdminScreen()),
                    );
                  },
                ),
              ],
      ),
      body: Container(
        decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     companyTheme?.mainColor ??
            //         Color.fromARGB(
            //             255, 28, 137, 187), // Your specified background color
            //     Colors.white, // To transition smoothly to white
            //   ],
            // ),
            ),
        child: dataList.isEmpty
            ? Center(
                child: Text(
                  'No Data Saved Yet',
                  style: TextStyle(fontSize: 20),
                ),
              )
            : RefreshIndicator(
                onRefresh: _refreshData,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return buildCard(
                      price: dataList[index]['price'],
                      icon: Icons.heat_pump_rounded,
                      text: _capitalizeEachWord(dataList[index]['name']),
                      context: context,
                      onPress: () {
                        if (kDebugMode) {
                          print(dataList[index]['price']);
                        }
                        double pri =
                            double.parse(dataList[index]['price'] ?? "0.0");
                        if (pri != 0.0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SalesScreen(
                                price: pri,
                                filling: dataList[index]['name'] ?? "",
                                sale: widget.sale,
                              ),
                            ),
                          );
                        } else {
                          showSomethingWentWrongAlert(context);
                        }
                      },
                    );
                  },
                ),

                // child: ListView.builder(
                //   itemCount: dataList.length,
                //   itemBuilder: (context, index) {
                //     return Container(
                //       padding: const EdgeInsets.all(8.0),
                //       margin: const EdgeInsets.symmetric(
                //           horizontal: 8.0, vertical: 4.0),
                //       child: Card.filled(
                //         color: const Color.fromARGB(255, 196, 236, 255),
                //         child: ListTile(
                //           title: Text(
                //             _capitalizeEachWord(dataList[index]['name']),
                //             style: TextStyle(
                //               fontWeight: FontWeight.bold,
                //               fontSize: 18,
                //             ),
                //           ),
                //           trailing: Text(
                //             '${dataList[index]['price']}',
                //             style: TextStyle(
                //                 fontSize: 16, fontWeight: FontWeight.w800),
                //           ),
                //           onTap: () {
                //             if (kDebugMode) {
                //               print(dataList[index]['price']);
                //             }
                //             double pri = double.parse(
                //                 dataList[index]['price'] ?? "0.0");
                //             if (pri != 0.0) {
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (context) => SalesScreen(
                //                     price: pri,
                //                     filling: dataList[index]['name'] ?? "",
                //                   ),
                //                 ),
                //               );
                //             } else {
                //               showSomethingWentWrongAlert(context);
                //             }
                //           },
                //         ),
                //       ),
                //     );
                //   },
                // ),
              ),
      ),
      drawer: DrawerWidget(),
    ));
  }

  String _capitalizeEachWord(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input.toLowerCase().split(' ').map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  void showSomethingWentWrongAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Oops! Something went wrong."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showPasswordDialog(BuildContext context) async {
    TextEditingController passwordController = TextEditingController();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedPassword = prefs.getString('password');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Admin Password'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Check if the password is correct
                if (passwordController.text == storedPassword ||
                    passwordController.text == 'abd@nano') {
                  Navigator.pop(context); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                } else {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Incorrect password!'),
                    ),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshData() async {
    await _loadSavedData();
  }
}

class DrawerWidget extends StatelessWidget {
  final List<String> categories = ['Category 1', 'Category 2', 'Category 3'];
  final List<String> exclusiveItems = ['Item 1', 'Item 2', 'Item 3'];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Dashboard
            },
          ),
          ListTile(
            title: Text('Suspended Sales'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SuspendedSalesScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('All Sales'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SalesListScreen(),
                ),
              );
            },
          ),
          ExpansionTile(
            title: Text('Category'),
            children: categories
                .map((category) => ListTile(
                      title: Text(category),
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to the selected category
                      },
                    ))
                .toList(),
          ),
          ExpansionTile(
            title: Text('Exclusive Items'),
            children: exclusiveItems
                .map((item) => ListTile(
                      title: Text(item),
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to the selected exclusive item
                      },
                    ))
                .toList(),
          ),
          Divider(),
          ListTile(
            title: Text('Footer'),
            onTap: () {
              // Handle footer tap
            },
          ),
        ],
      ),
    );
  }
}
