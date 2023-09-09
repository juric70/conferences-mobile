import 'dart:async';
import 'dart:convert';

import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/model/organization.dart';
import 'package:conferences_mobile/network/api_constances.dart';
import 'package:http/http.dart' as http;

class OrganizationService {
  static Future<String> createOrganization(String data) async {
    final Map<String, dynamic> pack = jsonDecode(data);
    UserModel? user = await AuthModel().LoggedInUser();
    final dataForResponse = {
      'user_id': user?.id,
      'name': pack['name'],
      'address': pack['address'],
      'description': pack['description'],
      'city_id': pack['city_id'],
      'organization_type_id': pack['organization_type_id'],
    };
    final jsonData = jsonEncode(dataForResponse);
    final response = await http.post(
      Uri.parse('${ApiConstances.baseUrl}organizations'),
      body: jsonData,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': 'laravel_session=cookie_user',
      },
    );
    try {
      if (response.statusCode == 201) {
        return '200';
      } else {
        return response.body;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> editOrganization(String data, int id) async {
    final response = await http.put(
      Uri.parse('${ApiConstances.baseUrl}organizations/$id'),
      body: data,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': 'laravel_session=cookie_user',
      },
    );
    try {
      if (response.statusCode == 200) {
        return '200';
      } else {
        return response.body;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<Organization>> getOrganizationsByUser(int id) async {
    try {
      final response = await http
          .get(Uri.parse('${ApiConstances.baseUrl}organizations/$id/users'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Organization> organization =
            data.map((json) => Organization.fromJson(json)).toList();
        return organization;
      } else {
        return List.empty();
      }
    } catch (e) {
      throw Future.error(e);
    }
  }

  static Future<List<Organization>> getOrganizations() async {
    try {
      final response =
          await http.get(Uri.parse('${ApiConstances.baseUrl}organizations'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Organization> organization =
            data.map((json) => Organization.fromJson(json)).toList();
        return organization;
      } else {
        return List.empty();
      }
    } catch (e) {
      throw Future.error(e);
    }
  }

  static Future<int> getIdOfCreatorOfOrganization(int organizationId) async {
    try {
      final response = await http.get(
          Uri.parse('${ApiConstances.baseUrl}organizations/$organizationId'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Organization organization = Organization.fromJson(data);
        return organization.creatorId;
      } else {
        return -1;
      }
    } catch (e) {
      throw Future.error(e);
    }
  }

  static Future<Organization> getOfOrganizationDetails(
      int organizationId) async {
    try {
      final response = await http.get(
          Uri.parse('${ApiConstances.baseUrl}organizations/$organizationId'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Organization organization = Organization.fromJson(data);
        return organization;
      } else {
        return Organization();
      }
    } catch (e) {
      throw Future.error(e);
    }
  }
}
