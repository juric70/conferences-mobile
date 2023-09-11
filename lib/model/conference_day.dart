import 'package:conferences_mobile/model/category.dart';
import 'package:conferences_mobile/model/timetable.dart';
import 'package:flutter/material.dart';

class ConferenceDay {
  int id, day_number, price, conferenceId;
  String date, conference, date_of_conf_day;
  List<Timetable>? timetables;
  List<Category>? categories;

  ConferenceDay(
      {this.id = 0,
      this.day_number = 0,
      this.price = 0,
      this.date = '',
      this.conference = '',
      this.date_of_conf_day = '',
      this.timetables,
      this.categories,
      this.conferenceId = 0});

  static Color hexToColor(String code) {
    Color col = Color(int.parse(code.substring(0, 6), radix: 16) + 0xff000000);
    return col;
  }

  factory ConferenceDay.fromJson(Map<String, dynamic> json) {
    String startingDate = json['conference']['starting_date'] ?? '';
    DateTime startingDateD = DateTime.tryParse(startingDate) ?? DateTime.now();
    int dayNumber = json['day_number'] ?? 0;
    DateTime conferenceDayDate = startingDateD.add(Duration(days: dayNumber));
    List<Timetable> listOfTimetables = [];
    List<Category> listOfCategories = [];
    var timetables = json['timetable'] as List<dynamic>?;
    var cat = json['categories'] as List<dynamic>;
    for (var category in cat) {
      Color catColor = hexToColor(category['color']);
      Category cat = Category(
        color: catColor,
        name: category['name'],
      );
      listOfCategories.add(cat);
    }

    for (var timetable in timetables!) {
      Timetable timet = Timetable(
        id: timetable['id'] ?? 0,
        availableSeats: timetable['available_seats'] ?? 0,
        startingTime: timetable['start_time'] ?? '',
        endingTime: timetable['end_time'] ?? '',
        title: timetable['title'] ?? '',
        address: timetable['address'] ?? '',
        conferenceRoom: timetable['conference_room'] ?? '',
        description: timetable['description'] ?? '',
        host: timetable['user']['name'] ?? '',
      );
      listOfTimetables.add(timet);
    }
    return ConferenceDay(
        id: json['id'] ?? 0,
        day_number: dayNumber,
        price: json['price'] ?? 0,
        date: json['date'] ?? '',
        conference: json['conference']['name'] ?? '',
        date_of_conf_day: conferenceDayDate.toString(),
        conferenceId: json['conference']['id'] ?? 0,
        timetables: listOfTimetables,
        categories: listOfCategories);
  }
}
