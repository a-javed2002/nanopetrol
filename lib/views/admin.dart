import 'package:flutter/material.dart';
import 'package:petrol/company.dart';
import 'package:petrol/company_form.dart';
import 'package:petrol/models/theme.dart';
import 'package:petrol/notifiers/theme.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the company theme data using Provider
    CompanyTheme? companyTheme =
        Provider.of<CompanyThemeProvider>(context).currentTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Company Screen'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.movie_edit,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CompanyFormScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.maps_home_work,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CompanyListScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        // Apply the main color as the background color
        color: companyTheme?.mainColor ?? Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the company logo using the locally stored image
              // CachedNetworkImage(
              //   imageUrl: companyTheme?.logoUrl ?? '',
              //   placeholder: (context, url) => CircularProgressIndicator(),
              //   errorWidget: (context, url, error) => Icon(Icons.error),
              // ),
              companyTheme?.logoUrl != null
                  ? Image.file(
                      companyTheme!.logoUrl!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    )
                  : Placeholder(),
              SizedBox(height: 20),
              // Display the company name and description
              Text(
                'Company Name: ${companyTheme?.name ?? 'Unknown'}',
                style:
                    TextStyle(color: companyTheme?.otherColor ?? Colors.black),
              ),
              Text(
                'Company Description: ${companyTheme?.description ?? 'No Description'}',
                style:
                    TextStyle(color: companyTheme?.otherColor ?? Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
