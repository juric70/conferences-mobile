class PartnerType {
  int id;
  String name, description;

  PartnerType({
    this.id = 0,
    this.name = '',
    this.description = '',
  });

  factory PartnerType.fromJson(Map<String, dynamic> json) {
    return PartnerType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
