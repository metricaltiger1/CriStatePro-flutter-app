class HouseModel {
  int houseId;
  int userId;
  String userFullname;
  String houseType;
  String houseTitle;
  String transactionType;
  String houseDescription;
  String houseBedrooms;
  String houseBathrooms;
  String houseAmenities;
  String rentalTerms;
  String contactInfo;
  double housePrice;
  String houseLocation;
  String houseProfileImage;
  String createdAt;
  List<String> displayImages;
  double averageRating;
  int totalRatings;
  String videoUrl;
  String thumbnailUrl;

  HouseModel(
    this.houseId,
    this.userId,
    this.userFullname,
    this.houseType,
    this.houseTitle,
    this.transactionType,
    this.houseDescription,
    this.houseBedrooms,
    this.houseBathrooms,
    this.houseAmenities,
    this.rentalTerms,
    this.contactInfo,
    this.housePrice,
    this.houseLocation,
    this.houseProfileImage,
    this.createdAt,
    this.displayImages,
    this.averageRating,
    this.totalRatings,
    this.thumbnailUrl,
    this.videoUrl,
  );

  factory HouseModel.fromJson(Map<String, dynamic> json) {
    return HouseModel(
      int.parse(json['house_id'] ?? '0'),
      int.parse(json['user_id'] ?? '0'),
      json['user_fullname'] ?? '',
      json['house_type'] ?? '',
      json['house_title'] ?? '',
      json['transaction_type'] ?? '',
      json['house_description'] ?? '',
      json['house_bedrooms'] ?? '',
      json['house_bathrooms'] ?? '',
      json['house_amenities'] ?? '',
      json['rental_terms'] ?? '',
      json['contact_info'] ?? '',
      double.parse(json['house_price'] ?? '0.0'),
      json['house_location'] ?? '',
      json['house_profile_image'] ?? '',
      json['created_at'] ?? '',
      List<String>.from(json['display_images'] ?? []),
      double.parse(json['average_rating'] ?? '0.0'),
      int.parse(json['total_ratings'] ?? '0'),
      json['video_thumbnail'] ?? '',
      json['video_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'house_id': houseId,
        'user_id': userId,
        'user_fullname': userFullname,
        'house_type': houseType,
        'house_title': houseTitle,
        'transaction_type': transactionType,
        'house_description': houseDescription,
        'house_bedrooms': houseBedrooms,
        'house_bathrooms': houseBathrooms,
        'house_amenities': houseAmenities,
        'rental_terms': rentalTerms,
        'contact_info': contactInfo,
        'house_price': housePrice,
        'house_location': houseLocation,
        'house_profile_image': houseProfileImage,
        'created_at': createdAt,
        'display_images': displayImages,
        'average_rating': averageRating,
        'total_ratings': totalRatings,
        'video_thumbnail': thumbnailUrl,
        'video_name': videoUrl,
      };
}
