class City {
  int id, state_id;
  String name, zip_code, country, country_code;

  City({
    this.id = 0,
    this.name = '',
    this.zip_code = '',
    this.state_id = 0,
    this.country = '',
    this.country_code = '',
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      zip_code: json['zip_code'] ?? '',
      state_id: json['state_id'] ?? 0,
      country: json['country']['name'] ?? '',
      country_code: json['country']['code'] ?? '',
    );
  }
}
