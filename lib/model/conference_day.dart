import 'package:conferences_mobile/model/category.dart';
import 'package:conferences_mobile/model/timetable.dart';

class ConferenceDay {
  int id, day_number, price;
  String date, conference, date_of_conf_day;
  List<Timetable>? timetables;
  List<Category>? categories;

  ConferenceDay({
    this.id = 0,
    this.day_number = 0,
    this.price = 0,
    this.date = '',
    this.conference = '',
    this.date_of_conf_day = '',
    this.timetables,
    this.categories,
  });

  factory ConferenceDay.fromJson(Map<String, dynamic> json) {
    String startingDate = json['conference']['starting_date'] ?? '';
    DateTime startingDateD = DateTime.tryParse(startingDate) ?? DateTime.now();
    int dayNumber = json['day_number'] ?? 0;
    DateTime conferenceDayDate = startingDateD.add(Duration(days: dayNumber));
    return ConferenceDay(
      id: json['id'] ?? 0,
      day_number: dayNumber,
      price: json['price'] ?? 0,
      date: json['date'] ?? '',
      conference: json['conference']['name'] ?? '',
      date_of_conf_day: conferenceDayDate.toString(),
    );
  }
}
