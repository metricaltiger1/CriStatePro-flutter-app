class HouseArchitect {
  final String name;
  final String specialization;
  final String description;
  final String image;
  final String contact;
  final String location;

  HouseArchitect({
    required this.name,
    required this.specialization,
    required this.description,
    required this.image,
    required this.contact,
    required this.location,
  });

  factory HouseArchitect.fromJson(Map<String, dynamic> json) {
    return HouseArchitect(
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      contact: json['contact'] ?? '',
      location: json['location'] ?? '',
    );
  }
}
