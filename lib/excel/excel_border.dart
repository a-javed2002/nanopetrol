import 'dart:io';
import 'package:excel/excel.dart';

class ExcelGenerator {
  late Excel _excel;
  late Sheet _sheet;

  ExcelGenerator() {
    _excel = Excel.createExcel();
    _sheet = _excel['Sheet1']!;
  }

  void addMergedCell(int startColumn, int startRow, int endColumn, int endRow) {
    _sheet.merge(
      CellIndex.indexByColumnRow(columnIndex: startColumn, rowIndex: startRow),
      CellIndex.indexByColumnRow(columnIndex: endColumn, rowIndex: endRow),
    );
  }

  void addMergedCellBorder(int startColumn, int startRow, int endColumn, int endRow) {
    Border border = Border(
      borderColorHex: "#FF000000".excelColor,
      borderStyle: BorderStyle.Thin,
    );

    _sheet.setMergedCellStyle(
      CellIndex.indexByColumnRow(columnIndex: startColumn, rowIndex: startRow),
      CellStyle(
        topBorder: border,
        bottomBorder: border,
        leftBorder: border,
        rightBorder: border,
        diagonalBorder: border,
        diagonalBorderDown: true,
        diagonalBorderUp: true,
      ),
    );
  }

  void addCellWithBorder(int column, int row, String text) {
    Border border = Border(
      borderColorHex: "#FF000000".excelColor,
      borderStyle: BorderStyle.Thin,
    );

    _sheet.updateCell(
      CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
      TextCellValue(text),
      cellStyle: CellStyle(
        topBorder: border,
        bottomBorder: border,
        leftBorder: border,
        rightBorder: border,
        diagonalBorder: border,
      ),
    );
  }

  void setColumnWidth(int column, double width) {
    _sheet.setColumnWidth(column, width);
  }

  List<int>? saveToFile(String outputFile) {
    List<int>? fileBytes = _excel.encode();
    if (fileBytes != null) {
      File(outputFile)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }
    return fileBytes;
  }
}

void main(List<String> args) {
  var excelGenerator = ExcelGenerator();

  excelGenerator.addMergedCell(1, 1, 10, 5);
  excelGenerator.addMergedCellBorder(1, 1, 10, 5);
  excelGenerator.addMergedCellBorder(2, 10, 5, 10);
  excelGenerator.addCellWithBorder(0, 1, "Normal border");
  excelGenerator.setColumnWidth(0, 50);

  excelGenerator.saveToFile("excel_custom.xlsx");
}
