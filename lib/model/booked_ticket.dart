import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/model/conference_day.dart';
import 'package:conferences_mobile/model/users_offer.dart';

class BookedTicket {
  int id;
  int userId;
  int conferenceDayId;
  int? usersOfferId;
  int price;
  int paid;
  DateTime? paymentDate;
  DateTime createdAt;
  DateTime updatedAt;
  UserModel user;
  ConferenceDay conferenceDay;
  UsersOffer? usersOffer;

  BookedTicket({
    required this.id,
    required this.userId,
    required this.conferenceDayId,
    this.usersOfferId,
    required this.price,
    required this.paid,
    this.paymentDate,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.conferenceDay,
    this.usersOffer,
  });

  factory BookedTicket.fromJson(Map<String, dynamic> json) {
    return BookedTicket(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      conferenceDayId: json['conference_day_id'] ?? 0,
      usersOfferId: json['users_offer_id'],
      price: json['price'] ?? 0,
      paid: json['paid'] ?? 0,
      paymentDate: json['payment_date'] != null
          ? DateTime.parse(json['payment_date'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: UserModel.fromJson(json['user']),
      conferenceDay: ConferenceDay.fromJson(json['conference_day']),
      usersOffer: json['users_offer'] != null
          ? UsersOffer.fromJson(json['users_offer'])
          : null,
    );
  }
}
