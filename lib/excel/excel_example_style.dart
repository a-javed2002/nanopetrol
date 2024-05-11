import 'dart:io';
import 'package:path/path.dart';
import 'package:excel/excel.dart';

class ExcelExampleStyle {
  void writeExcel() {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];

    sheet.appendRow([
      IntCellValue(8),
      DoubleCellValue(999.62221),
      DateCellValue(
        year: DateTime.now().year,
        month: DateTime.now().month,
        day: DateTime.now().day,
      ),
      DateTimeCellValue.fromDateTime(DateTime.now()),
    ]);

    // Saving the file
    String outputFile = './example/example.xlsx';

    List<int>? fileBytes = excel.save();
    if (fileBytes != null) {
      File(join(outputFile))
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }
  }
}

void main(List<String> args) {
  ExcelExampleStyle().writeExcel();
}
