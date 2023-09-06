class OrganizationsOffer {
  int id, price, publishable_conferences;
  String kind, description;

  OrganizationsOffer({
    this.id = 0,
    this.price = 0,
    this.publishable_conferences = 0,
    this.kind = '',
    this.description = '',
  });

  factory OrganizationsOffer.fromJson(Map<String, dynamic> json) {
    return OrganizationsOffer(
      id: json['id'] ?? 0,
      price: json['price'] ?? 0,
      publishable_conferences: json['publishable_conferences'] ?? 0,
      kind: json['kind'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
