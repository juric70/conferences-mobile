import 'package:conferences_mobile/network/api_constances.dart';
import 'package:http/http.dart' as http;

class ConferenceDayService {
  static Future<String> createConferenceDay(String data) async {
    final response = await http.post(
      Uri.parse('${ApiConstances.baseUrl}conferenceDay'),
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

  static Future<String> addCategoryToConferenceDay(String data, int id) async {
    final response = await http.post(
      Uri.parse('${ApiConstances.baseUrl}conferenceDay/$id/categories'),
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
}
