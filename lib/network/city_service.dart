import 'package:conferences_mobile/model/city.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CityService {
  static String baseUrl = "http://10.0.2.2:8000/cities";

  static Future<List<City>> getCity() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<City> cityList =
            jsonList.map((json) => City.fromJson(json)).toList();
        return cityList;
      } else {
        // print('${response.statusCode}');
        return List.empty();
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<City> getCityDetails(int cityId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$cityId'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final City city = City.fromJson(data);
        return city;
      } else {
        print(response.statusCode);
        return City();
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
