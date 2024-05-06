import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

// Function to generate Excel sheet
Future<void> generateExcel(List<Map<String, dynamic>> salesData) async {
  // Create Excel workbook
  var excel = Excel.createExcel();
  var sheet = excel['Sales'];


  // Headers -- issue
  // sheet.appendRow([]);

  // Sales data
  salesData.forEach((sale) {
    sheet.appendRow([sale['date'], sale['amount']]);
  });

  // Save Excel file
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String filePath = '${appDocumentsDirectory.path}/sales_data.xlsx';
  File(filePath).writeAsBytesSync(excel.encode()!);


  // Show message
  print('Excel file generated: $filePath');
}

// Example usage
void main() async {
  List<Map<String, dynamic>> salesData = [
    {'date': '2024-05-01', 'amount': 100},
    {'date': '2024-05-02', 'amount': 150},
    {'date': '2024-05-03', 'amount': 200},
  ];

  await generateExcel(salesData);
}
