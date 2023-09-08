import 'package:flutter/material.dart';

class Category {
  int id;
  String name;
  Color? color;

  Category({
    this.id = 0,
    this.name = '',
    this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    Color? categoryColor;
    final colorHex = json['color'];
    if (colorHex != null && colorHex is String && colorHex.length >= 6) {
      categoryColor = hexToColor(colorHex);
    }
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      color: categoryColor,
    );
  }
  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xff000000);
  }
}
