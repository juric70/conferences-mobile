class UsersOffer {
  int id, number_of_days, price;
  String kind, code, description;

  UsersOffer({
    this.id = 0,
    this.number_of_days = 0,
    this.price = 0,
    this.kind = '',
    this.code = '',
    this.description = '',
  });

  factory UsersOffer.fromJson(Map<String, dynamic> json) {
    return UsersOffer(
      id: json['id'] ?? 0,
      number_of_days: json['number_of_days'] ?? 0,
      price: json['price'] ?? 0,
      kind: json['kind'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
