import 'package:flutter/material.dart';
import 'package:petrol/models/theme.dart';

class CompanyThemeProvider with ChangeNotifier {
  CompanyTheme? _currentTheme;

  CompanyTheme? get currentTheme => _currentTheme;

  void setCompanyDetails(CompanyTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}
