class Organization {
  // ignore: non_constant_identifier_names
  int id,
      publishableNumber,
      usageNumber,
      approveed,
      creatorId,
      organizationTypeId,
      cityId;
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
    this.creatorId = 0,
    this.cityId = 0,
    this.organizationTypeId = 0,
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
      creatorId: json['user']['id'] ?? '',
      city: json['city']['name'] ?? '',
      cityId: json['city']['id'] ?? 0,
      organizationTypeId: json['organization_type']['id'] ?? 0,
      organizationType: json['organization_type']['name'] ?? '',
    );
  }
}
