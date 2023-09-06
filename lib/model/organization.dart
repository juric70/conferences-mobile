class Organization {
  // ignore: non_constant_identifier_names
  int id, publishableNumber, usageNumber, approveed;
  String name, address, description, city, creator, organizationType;

  Organization({
    this.id = 0,
    this.publishableNumber = 0,
    this.usageNumber = 0,
    this.name = '',
    this.address = '',
    this.description = '',
    this.city = '',
    this.creator = '',
    this.organizationType = '',
    this.approveed = 0,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'] ?? 0,
      usageNumber: json['usage_number'] ?? 0,
      publishableNumber: json['publishable_number'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      description: json['description'] ?? '',
      approveed: json['approved'] ?? 0,
      creator: json['user']['name'] ?? '',
      city: json['city']['name'] ?? '',
      organizationType: json['organization_type']['name'] ?? '',
    );
  }
}
