import 'dart:convert';

import 'package:conferences_mobile/model/organizations_offer.dart';
import 'package:http/http.dart' as http;
import 'package:conferences_mobile/network/api_constances.dart';

class OrganizationsOfferService {
  static Future<List<OrganizationsOffer>> getOrganizationsOffers() async {
    try {
      final response = await http
          .get(Uri.parse('${ApiConstances.baseUrl}organizationsOffers'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<OrganizationsOffer> organizationOffersList =
            jsonList.map((json) => OrganizationsOffer.fromJson(json)).toList();
        return organizationOffersList;
      } else {
        return List.empty();
      }
    } catch (e) {
      throw Future.error(e);
    }
  }

  static Future<OrganizationsOffer> getOrganizationsOffer(int id) async {
    try {
      final response = await http
          .get(Uri.parse('${ApiConstances.baseUrl}organizationsOffers/$id'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final OrganizationsOffer organizationsOffer =
            OrganizationsOffer.fromJson(data);
        return organizationsOffer;
      } else {
        return OrganizationsOffer();
      }
    } catch (e) {
      throw Future.error(e);
    }
  }

  static Future<int> buySubscription(String data) async {
    final Map<String, dynamic> pack = jsonDecode(data);
    int organizationsOfferId = pack['organizationOffer'];
    int organizationId = pack['organization'];
    final dataForResponse = {
      'organizations_offer_id': organizationsOfferId,
    };
    final jsonData = jsonEncode(dataForResponse);
    final response = await http.post(
      Uri.parse('${ApiConstances.baseUrl}subscriptions/$organizationId'),
      body: jsonData,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': 'laravel_session=cookie_user',
      },
    );
    try {
      if (response.statusCode == 201) {
        return 200;
      } else {
        return 400;
      }
    } catch (e) {
      throw Future.error(e);
    }
  }
}
