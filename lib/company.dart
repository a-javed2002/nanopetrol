import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petrol/comapny_form_update.dart';

class CompanyListScreen extends StatelessWidget {
  const CompanyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company List'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('companies').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No companies found.'),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),
                subtitle: Text(data['description']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CompanyDetailScreen(companyData: data,companyID: document.id,),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class CompanyDetailScreen extends StatefulWidget {
  final Map<String, dynamic> companyData;
  final String companyID;

  const CompanyDetailScreen({required this.companyData,required this.companyID});

  @override
  _CompanyDetailScreenState createState() => _CompanyDetailScreenState();
}

class _CompanyDetailScreenState extends State<CompanyDetailScreen> {
  // TextEditingController _petrolController = TextEditingController();
  // TextEditingController _dieselController = TextEditingController();
  // TextEditingController _lightDieselController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _petrolController.text = widget.companyData['prices']['Jan']['petrol'];
    // _dieselController.text = widget.companyData['prices']['Jan']['diesel'];
    // _lightDieselController.text = widget.companyData['prices']['Jan']['lightDiesel'];
  }

  @override
  Widget build(BuildContext context) {
    print(widget.companyData['images']['logo']);
    print(widget.companyData['images']['cover']);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.companyData['name']),
        actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.more_horiz_rounded,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CompanyUpdateScreen(companyId: widget.companyID,)),
                );
              },
            ),
          ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.companyData['description']),
            const SizedBox(height: 20),
            Image.network(
              widget.companyData['images']['logo'],
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                // If an error occurs while fetching the image, display a fallback image from assets
                return Image.asset(
                  'assets/no-image.jpg', // Provide the path to the fallback image in the assets folder
                  width: 100, // Adjust width and height as needed
                  height: 100,
                );
              },
            ),
            const SizedBox(height: 20),
            Image.network(
              widget.companyData['images']['cover'],
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                // If an error occurs while fetching the image, display a fallback image from assets
                return Image.asset(
                  'assets/no-image.jpg', // Provide the path to the fallback image in the assets folder
                  width: 200, // Adjust width and height as needed
                  height: 200,
                );
              },
            ),

            // Text(
            //   'Colors:',
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // SizedBox(height: 10),
            // TextFormField(
            //   controller: _petrolController,
            //   decoration: InputDecoration(labelText: 'Price for Petrol'),
            //   keyboardType: TextInputType.number,
            // ),
            // TextFormField(
            //   controller: _dieselController,
            //   decoration: InputDecoration(labelText: 'Price for Diesel'),
            //   keyboardType: TextInputType.number,
            // ),
            // TextFormField(
            //   controller: _lightDieselController,
            //   decoration: InputDecoration(labelText: 'Price for Light Diesel'),
            //   keyboardType: TextInputType.number,
            // ),

            // SizedBox(height: 20),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ElevatedButton(
            //       onPressed: _updatePrices,
            //       child: Text('Update Prices'),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  void _updatePrices() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore
          .collection('companies')
          .doc(widget.companyData['id'])
          .update({
        // 'prices.Jan.petrol': _petrolController.text,
        // 'prices.Jan.diesel': _dieselController.text,
        // 'prices.Jan.lightDiesel': _lightDieselController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prices updated successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update prices: $error')),
      );
    }
  }
}
