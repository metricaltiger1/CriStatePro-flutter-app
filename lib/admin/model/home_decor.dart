class HomeDecorItem {
  final String id;
  final String image;
  final String name;
  final String description;
  final double price;
  final String location;

  HomeDecorItem({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.location,
  });

  factory HomeDecorItem.fromJson(Map<String, dynamic> json) {
    return HomeDecorItem(
      id: json['id'] ?? '',
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.parse(json['price']?.toString() ?? '0'),
      location: json['location'] ?? '',
    );
  }
}
