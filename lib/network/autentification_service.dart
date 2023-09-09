import 'dart:convert';
//import 'dart:js';

import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/network/api_constances.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthentificationService extends AuthModel {
  static Future<String> registerUser(String data, BuildContext context) async {
    final response = await http.post(
      Uri.parse('${ApiConstances.baseUrl}register'),
      body: data,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': 'laravel_session=cookie_user',
      },
    );
    try {
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cookie', response.headers['set-cookie']!);
        return ('');
      } else if (response.statusCode == 422) {
        return response.body;
      } else {
        return ('');
      }
    } catch (e) {
      return (jsonEncode(response.body));
    }
  }

  static Future<int> loginUser(String data) async {
    final response = await http.post(
      Uri.parse('${ApiConstances.baseUrl}login'),
      body: data,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': 'laravel_session=cookie_user',
      },
    );
    if (response.statusCode == 204) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cookie', response.headers['set-cookie']!);
      UserModel? user = await AuthModel().LoggedInUser();
      if (user != null) {
        return (200);
      } else {
        return (500);
      }
    } else if (response.statusCode == 404) {
      return (401);
    } else {
      return (1);
    }
  }

  static Future<String> logout() async {
    final response = await http.post(
      Uri.parse('${ApiConstances.baseUrl}logout'),
    );
    if (response.statusCode == 204) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cookie');
      UserModel? user = await AuthModel().LoggedInUser();
      if (user != null) {
        return ('greska');
      } else {
        return ('okej');
      }
    } else if (response.statusCode == 404) {
      return ('vec je odjavljen');
    } else {
      return ('nez');
    }
  }

  static Future<int> getUserRoleId() async {
    final response = await http.get(Uri.parse('${ApiConstances.baseUrl}roles'));
    if (response.statusCode == 200) {
      final List<dynamic> rolesData = json.decode(response.body);

      for (var roleData in rolesData) {
        if (roleData['name'] == 'user') {
          return int.parse(roleData['id']);
        }
      }
      throw Exception('User not found');
    } else {
      throw Exception('Failed to fetch roles');
    }
  }

  static Future<int> getUserByEmail(String email) async {
    try {
      final response =
          await http.get(Uri.parse('${ApiConstances.baseUrl}users/$email'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final UserModel user = UserModel.fromJson(data);
        return user.id;
        // return int.parse(user['id']);
      } else {
        return -1;
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<List<UserModel>> getUsers() async {
    try {
      final response =
          await http.get(Uri.parse('${ApiConstances.baseUrl}users'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<UserModel> users =
            jsonList.map((json) => UserModel.fromJson(json)).toList();

        return users;
      } else {
        return List.empty();
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
