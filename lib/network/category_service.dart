import 'package:conferences_mobile/network/api_constances.dart';

import '../model/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryService {
  static Future<List<Category>> getCategory() async {
    try {
      final response =
          await http.get(Uri.parse('${ApiConstances.baseUrl}categories'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<Category> categoryList =
            jsonList.map((json) => Category.fromJson(json)).toList();
        return categoryList;
      } else {
        return List.empty();
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Category> getCategoryDetails(int categoryId) async {
    try {
      final response = await http
          .get(Uri.parse('${ApiConstances.baseUrl}categories/$categoryId'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Category category = Category.fromJson(data);
        return category;
      } else {
        return Category();
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
