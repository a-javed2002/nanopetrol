import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path/path.dart';

class ExcelExample {
  late Excel _excel;

  ExcelExample();

  void createExcel() {
    _excel = Excel.createExcel();
  }

  void readExcel() {
    for (var table in _excel.tables.keys) {
      print(table);
      print(_excel.tables[table]!.maxColumns);
      print(_excel.tables[table]!.maxRows);
      for (var row in _excel.tables[table]!.rows) {
        print("${row.map((e) => e?.value)}");
      }
    }
  }

  void changeSheetDirection(String sheetName, bool isRTL) {
    _excel[sheetName].isRTL = isRTL;
    print(
        '$sheetName: ((previous) isRTL: ${!isRTL}) ---> ((current) isRTL: ${isRTL})');
  }

  void applyCellStyle(String sheetName, String cellIndex, CellStyle cellStyle) {
    var cell = _excel[sheetName].cell(CellIndex.indexByString(cellIndex));
    cell.cellStyle = cellStyle;
  }

  void changeCellValue(String sheetName, String cellIndex, String value) {
    var cell = _excel[sheetName].cell(CellIndex.indexByString(cellIndex));
    cell.value = TextCellValue(value);
  }

  void iterateAndChangeValues(String sheetName) {
    var sheet = _excel[sheetName];
    for (int row = 0; row < sheet.maxRows; row++) {
      sheet.row(row).forEach((Data? cell) {
        if (cell != null) {
          cell.value = TextCellValue('My custom Value');
        }
      });
    }
  }

  void renameSheet(String oldName, String newName) {
    _excel.rename(oldName, newName);
  }

  void copySheet(String fromSheet, String newSheetName) {
    _excel.copy(fromSheet, newSheetName);
  }

  void deleteSheet(String sheetName) {
    _excel.delete(sheetName);
  }

  void unlinkSheet(String sheetName) {
    _excel.unLink(sheetName);
  }

  void appendRows(String sheetName, List<List<TextCellValue>> rows) {
    var sheet = _excel[sheetName];
    rows.forEach((row) {
      sheet.appendRow(row);
    });
  }

  bool setDefaultSheet(String sheetName) {
    return _excel.setDefaultSheet(sheetName);
  }

  void saveExcel(String outputFile) {
    List<int>? fileBytes = _excel.save();
    if (fileBytes != null) {
      File(join(outputFile))
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }
  }
}