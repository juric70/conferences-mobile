import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:conferences_mobile/network/api_constances.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  // final String roleName;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    //required this.roleName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      // roleName: json['role']['name'] ?? '',
    );
  }
}

class AuthModel extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  Future<UserModel?> LoggedInUser() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final cookie = sharedPreferences.getString('cookie') ?? '';

      final response = await http.get(
        Uri.parse('${ApiConstances.baseUrl}showUser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Cookie': cookie,
        },
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final Map<String, dynamic> userData = jsonDecode(response.body);
        _user = UserModel.fromJson(userData);
        notifyListeners();
        return _user;
      } else {
        _user = null;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _user = null;
      notifyListeners();
      return null;
    }
  }

  bool isLoggedIn() {
    UserModel? user = AuthModel().LoggedInUser() as UserModel?;
    if (user != []) {
      return false;
    } else {
      return true;
    }
  }
}
