import 'dart:convert';

import 'package:conferences_mobile/model/timetable.dart';
import 'package:conferences_mobile/network/api_constances.dart';
import 'package:http/http.dart' as http;

class TimetableService {
  static Future<String> createTimeTable(String data) async {
    final response = await http.post(
      Uri.parse('${ApiConstances.baseUrl}timetables'),
      body: data,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': 'laravel_session=cookie_user',
      },
    );
    try {
      if (response.statusCode == 201) {
        return '200';
      } else if (response.statusCode == 400) {
        return '-1';
      } else {
        return response.body;
      }
    } catch (e) {
      throw Future.error(e);
    }
  }

  static Future<String> editTimetable(String data, int id) async {
    final response = await http.put(
      Uri.parse('${ApiConstances.baseUrl}timetables/$id'),
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
      throw Future.error(e);
    }
  }

  static Future<Timetable> getTimetable(int id) async {
    try {
      final response =
          await http.get(Uri.parse('${ApiConstances.baseUrl}timetables/$id'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Timetable timetable = Timetable.fromJson(data);
        return timetable;
      } else {
        return Timetable();
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
