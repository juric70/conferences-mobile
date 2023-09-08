import 'dart:convert';
import 'package:conferences_mobile/model/auth.dart';
import 'package:http/http.dart' as http;
import 'package:conferences_mobile/network/api_constances.dart';
import 'package:conferences_mobile/model/conferences.dart';

class ConferenceServise {
  static Future<List<Conference>> getConferences() async {
    try {
      final response =
          await http.get(Uri.parse('${ApiConstances.baseUrl}conferences_all'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<Conference> conferences =
            jsonList.map((json) => Conference.fromJson(json)).toList();

        return conferences;
      } else {
        return List.empty();
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Conference> getConferenceDetail(int conferenceId) async {
    try {
      final response = await http
          .get(Uri.parse('${ApiConstances.baseUrl}conferences/$conferenceId'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Conference conference = Conference.fromJson(data);
        return conference;
      } else {
        return Conference();
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<int> getIdOfCreatorOfConference(int conferenceId) async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiConstances.baseUrl}conferences/$conferenceId/creator'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return -1;
      }
    } catch (e) {
      throw Future.error(e);
    }
  }

  static Future<String> buyTicket(String data) async {
    final Map<String, dynamic> pack = jsonDecode(data);

    String code = pack['code'];
    List<int> confDays = List<int>.from(pack['conf_days']);

    final responseForCode = await http
        .get(Uri.parse('${ApiConstances.baseUrl}usersOffers/id/$code'));

    if (responseForCode.statusCode == 200) {
      final Map<String, dynamic> codeIdBody = jsonDecode(responseForCode.body);
      int codeId = codeIdBody['id'];

      UserModel? user = await AuthModel().LoggedInUser();
      if (user != null) {
        int userId = user.id;
        final dataForResponse = {
          "user_id": userId,
          "conference_days": confDays,
          "users_offer_id": codeId
        };
        final jsonData = jsonEncode(dataForResponse);
        final response = await http.post(
          Uri.parse('${ApiConstances.baseUrl}tickets'),
          body: jsonData,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Cookie': 'laravel_session=cookie_user',
          },
        );
        if (response.statusCode == 201) {
          final List<dynamic> priceDataList = jsonDecode(response.body);
          int totalPrice = 0;
          for (final priceData in priceDataList) {
            int pricePerDay = priceData['price'];
            totalPrice += pricePerDay;
          }

          return ('Successfully reserved ticket! You need to pay $totalPrice.');
        } else {
          return ('something went wrong :(');
        }
      } else {
        return ('You must be logged in to book conference!');
      }
    } else {
      return ('Code you enter does not exist!');
    }
  }

  static Future<String> createConference(String data) async {
    final response = await http.post(
      Uri.parse('${ApiConstances.baseUrl}conferences'),
      body: data,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': 'laravel_session=cookie_user',
      },
    );
    try {
      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 400) {
        return '-1';
      } else {
        return response.body;
      }
    } catch (e) {
      throw Future.error(e);
    }
  }

  static Future<String> createPartners(int id, String data) async {
    final response = await http.post(
      Uri.parse('${ApiConstances.baseUrl}conferences/$id/partners'),
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
        return '400';
      }
    } catch (e) {
      throw Future.error(e);
    }
  }

  static Future<String> createUsersOffers(String data) async {
    final response = await http.post(
      Uri.parse('${ApiConstances.baseUrl}usersOffers'),
      body: data,
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
      throw Future.error(e);
    }
  }

  // static Future<int> reserveTicket(String data) async {
  //   final response = await http.post(
  //     Uri.parse('${ApiConstances.baseUrl}tickets'),
  //     body: data,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Cookie': 'laravel_session=cookie_user',
  //     },
  //   );
  //   try {
  //     if (response.statusCode == 200) {
  //       print('Success');
  //     }
  //     return 1;
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }
}
