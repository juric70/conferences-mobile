import 'dart:convert';

import 'package:conferences_mobile/model/users_offer.dart';
import 'package:http/http.dart' as http;
import 'package:conferences_mobile/network/api_constances.dart';

class UsersOfferService {
  static Future<List<UsersOffer>> getOffersForConference(
      int conferenceId) async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiConstances.baseUrl}usersOffers/$conferenceId/conferences'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<UsersOffer> usersOffersList =
            jsonList.map((json) => UsersOffer.fromJson(json)).toList();
        return usersOffersList;
      } else {
        return List.empty();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
