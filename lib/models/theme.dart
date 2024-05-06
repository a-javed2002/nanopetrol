import 'dart:io';

import 'package:flutter/material.dart';

class CompanyTheme {
  final Color mainColor;
  final Color lightColor;
  final Color otherColor;
  final String name;
  final String description;
  final File? logoUrl; // Change String to File
  final File? coverUrl; // Change String to File

  CompanyTheme({
    required this.mainColor,
    required this.lightColor,
    required this.otherColor,
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.coverUrl,
  });
}
