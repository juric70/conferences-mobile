class Timetable {
  int id, availableSeats;
  String? startingTime,
      endingTime,
      title,
      address,
      conferenceRoom,
      description,
      host;

  Timetable({
    this.id = 0,
    this.availableSeats = 0,
    this.startingTime = '',
    this.endingTime = '',
    this.title = '',
    this.address = '',
    this.conferenceRoom = '',
    this.description = '',
    this.host = '',
  });

  factory Timetable.fromJson(Map<String, dynamic> json) {
    return Timetable(
      id: json['id'] ?? 0,
      availableSeats: json['available_seats'] ?? 0,
      startingTime: json['starting_time'] ?? '',
      endingTime: json['ending_time'] ?? '',
      title: json['title'] ?? '',
      address: json['address'] ?? '',
      conferenceRoom: json['conference_room'] ?? '',
      description: json['description'] ?? '',
      host: json['user']['name'] ?? '',
    );
  }
}
