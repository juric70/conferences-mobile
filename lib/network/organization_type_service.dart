import 'dart:convert';

import 'package:conferences_mobile/model/organization_type.dart';
import 'package:conferences_mobile/network/api_constances.dart';
import 'package:http/http.dart' as http;

class OrganizationTypeService {
  static Future<List<OrganizationType>> getOrganizationTypes() async {
    final response =
        await http.get(Uri.parse('${ApiConstances.baseUrl}organizationTypes'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final List<OrganizationType> organizationTypeList =
          jsonList.map((json) => OrganizationType.fromJson(json)).toList();
      return organizationTypeList;
    } else {
      return List.empty();
    }
  }
}
