import 'dart:convert';

import 'package:conferences_mobile/model/partner_type.dart';
import 'package:conferences_mobile/network/api_constances.dart';
import 'package:http/http.dart' as http;

class PartnerTypeService {
  static Future<List<PartnerType>> getPartnerTypes() async {
    final response =
        await http.get(Uri.parse('${ApiConstances.baseUrl}partnerTypes'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final List<PartnerType> partnerTypeList =
          jsonList.map((json) => PartnerType.fromJson(json)).toList();
      return partnerTypeList;
    } else {
      return List.empty();
    }
  }
}
