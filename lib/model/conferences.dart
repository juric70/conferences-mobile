//import 'package:conferences_mobile/model/conference_day.dart';
import 'package:conferences_mobile/model/category.dart';
import 'package:conferences_mobile/model/conference_day.dart';
import 'package:conferences_mobile/model/timetable.dart';
import 'package:flutter/material.dart';

class Conference {
  int id, cityId;
  String name, description, organization, city, starting_date, ending_date;
  List<Category>? categories;
  List<ConferenceDay>? conferences_day;
  // List<ConferenceDay>? conferenceDay;

  Conference(
      {this.id = 0,
      this.cityId = 0,
      this.name = '',
      this.description = '',
      this.city = '',
      this.organization = '',
      this.starting_date = '',
      this.ending_date = '',
      this.categories,
      this.conferences_day});

  static Color hexToColor(String code) {
    Color col = Color(int.parse(code.substring(0, 6), radix: 16) + 0xff000000);
    return col;
  }

  factory Conference.fromJson(Map<String, dynamic> json) {
    List<Category> listOfCategories = [];
    List<Category> listOfCategoriesDay = [];
    var uniqueCategoryNames = <String>{};
    List<Timetable> listOfTimetables = [];
    List<ConferenceDay> listOfConfDays = [];

    if (json['conference_day'] != null) {
      var conferenceDayData = json['conference_day'] as List<dynamic>;

      for (var dayData in conferenceDayData) {
        listOfTimetables = [];
        listOfCategoriesDay = [];

        var timetables = dayData['timetable'] as List<dynamic>?;

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

        var categoriesData = dayData['categories'] as List<dynamic>;

        for (var categoryData in categoriesData) {
          var categoryName = categoryData['name'];
          Color categoryColor = hexToColor(categoryData['color']);
          if (!uniqueCategoryNames.contains(categoryName)) {
            uniqueCategoryNames.add(categoryName);
            Category cat = Category(
              color: categoryColor,
              name: categoryData['name'],
            );
            listOfCategories.add(cat);
          }
          Category cat = Category(
            color: categoryColor,
            name: categoryData['name'],
          );
          listOfCategoriesDay.add(cat);
        }
        ConferenceDay confDay = ConferenceDay(
          id: dayData['id'],
          day_number: dayData['day_number'],
          price: dayData['price'],
          date: dayData['date'],
          timetables: listOfTimetables,
          categories: listOfCategoriesDay,
        );
        listOfConfDays.add(confDay);
      }
      listOfConfDays.sort((a, b) => a.day_number.compareTo(b.day_number));
    }

    return Conference(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        city: json['city']['name'] ?? '',
        cityId: json['city']['id'] ?? 0,
        organization: json['organization']['name'] ?? '',
        starting_date: json['starting_date'] ?? '',
        ending_date: json['ending_date'] ?? '',
        conferences_day: listOfConfDays,
        categories: listOfCategories);
  }
}
