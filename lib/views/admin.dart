import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:petrol/company.dart';
import 'package:petrol/company_form.dart';
import 'package:petrol/models/theme.dart';
import 'package:petrol/notifiers/theme.dart';
import 'package:petrol/views/license.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';

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
          IconButton(
            icon: Icon(
              Icons.zoom_in,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LicenseVerificationScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.document_scanner,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ExcelScreen()),
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
              //   placeholder: (context, url) => const CircularProgressIndicator(),
              //   errorWidget: (context, url, error) => const Icon(Icons.error),
              // ),
              
              // companyTheme?.logoUrl != null
              //     ? Image.file(
              //         companyTheme!.logoUrl!,
              //         width: 150,
              //         height: 150,
              //         fit: BoxFit.contain,
              //       )
              //     : Placeholder(),
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
class ExcelScreen extends StatefulWidget {
  @override
  _ExcelScreenState createState() => _ExcelScreenState();
}

class _ExcelScreenState extends State<ExcelScreen> {
  Future<void> _generateExcel() async {
    // Create Excel file
    final excel = Excel.createExcel();
    final Sheet sheet = excel['Sheet1'];

    // Add headers
    sheet.appendRow([TextCellValue('ID'), TextCellValue('Name'), TextCellValue('Age')]);

    // Add dummy data
    for (int i = 1; i <= 10; i++) {
      sheet.appendRow([
        TextCellValue(i.toString()),
        TextCellValue('Person $i'),
        TextCellValue((20 + i).toString())
      ]);
    }

    // Save Excel file
    final String dir = (await getExternalStorageDirectory())!.path;
    final String path = '$dir/example.xlsx';
    await excel.save();

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Excel Generated'),
          content: Text('Excel file saved to $path'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Generator'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _generateExcel,
          child: Text('Generate Excel'),
        ),
      ),
    );
  }
}