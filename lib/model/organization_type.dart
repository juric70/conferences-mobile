class OrganizationType {
  int id;
  String name, description;

  OrganizationType({
    this.id = 0,
    this.name = '',
    this.description = '',
  });

  factory OrganizationType.fromJson(Map<String, dynamic> json) {
    return OrganizationType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
