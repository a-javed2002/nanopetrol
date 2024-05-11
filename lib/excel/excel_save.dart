import 'dart:io';
import 'package:excel/excel.dart';

class ExcelSave {
  late Excel _excel;

  ExcelSave() {
    _excel = Excel.createExcel();
  }

  void generateTestData() {
    const testSheetToKeep = 'Sheet To Keep';
    var listDynamic = (List<List<dynamic>>.generate(
      5,
      (_) => List<int>.generate(5, (i) => i + 1),
    )..insert(
        0,
        [
          'A',
          'B',
          'C',
          'D',
          'E',
        ],
      ));

    for (var row = 0; row < listDynamic.length; row++) {
      for (var column = 0; column < listDynamic[row].length; column++) {
        final cellIndex = CellIndex.indexByColumnRow(
          columnIndex: column,
          rowIndex: row,
        );
        var colorList = List.of(ExcelColor.values);
        final border = Border(
          borderColorHex: (colorList..shuffle()).first,
          borderStyle: BorderStyle.Thin,
        );

        final string = listDynamic[row][column].toString();

        var cellValue = int.tryParse(string) != null
            ? IntCellValue(int.parse(string))
            : TextCellValue(string);

        _excel.updateCell(
          testSheetToKeep,
          cellIndex,
          cellValue,
          cellStyle: CellStyle()
            ..backgroundColor = (colorList..shuffle()).first
            ..topBorder = border
            ..bottomBorder = border
            ..leftBorder = border
            ..rightBorder = border
            ..fontColor = (colorList..shuffle()).first
            ..fontFamily = 'Arial',
        );
      }
    }
  }

  void deleteDefaultSheet() {
    const defaultSheetName = 'Sheet1';
    if (_excel.sheets.keys.contains(defaultSheetName)) {
      _excel.delete(defaultSheetName);
    }
  }

  void renameSheet(String oldName, String newName) {
    _excel.rename(oldName, newName);
    _excel.setDefaultSheet(newName);
  }

  void saveExcel(String filePath) {
    final bytes = _excel.encode();
    if (bytes != null) {
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(bytes);
    }
  }
}
