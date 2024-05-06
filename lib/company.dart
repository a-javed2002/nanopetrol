import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company List'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('companies').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No companies found.'),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),
                subtitle: Text(data['description']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompanyDetailScreen(companyData: data),
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

  const CompanyDetailScreen({required this.companyData});

  @override
  _CompanyDetailScreenState createState() => _CompanyDetailScreenState();
}

class _CompanyDetailScreenState extends State<CompanyDetailScreen> {
  TextEditingController _petrolController = TextEditingController();
  TextEditingController _dieselController = TextEditingController();
  TextEditingController _lightDieselController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _petrolController.text = widget.companyData['prices']['Jan']['petrol'];
    _dieselController.text = widget.companyData['prices']['Jan']['diesel'];
    _lightDieselController.text = widget.companyData['prices']['Jan']['lightDiesel'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.companyData['name']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.companyData['description']),
            SizedBox(height: 20),
            Text(
              'Prices:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _petrolController,
              decoration: InputDecoration(labelText: 'Price for Petrol'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _dieselController,
              decoration: InputDecoration(labelText: 'Price for Diesel'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _lightDieselController,
              decoration: InputDecoration(labelText: 'Price for Light Diesel'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _updatePrices,
                  child: Text('Update Prices'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updatePrices() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('companies').doc(widget.companyData['id']).update({
        'prices.Jan.petrol': _petrolController.text,
        'prices.Jan.diesel': _dieselController.text,
        'prices.Jan.lightDiesel': _lightDieselController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Prices updated successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update prices: $error')),
      );
    }
  }
}
