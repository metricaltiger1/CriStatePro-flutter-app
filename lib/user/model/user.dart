import 'dart:convert';
import 'dart:typed_data';

class User {
  int userId;
  String userFirstName;
  String userLastName;
  int userNumber;
  String userEmail;
  String userPassword;
  Uint8List? userProfileImageData;
  String userRegistrationDate;
  int userRole;

  User(
    this.userId,
    this.userFirstName,
    this.userLastName,
    this.userNumber,
    this.userEmail,
    this.userPassword,
    this.userProfileImageData,
    this.userRegistrationDate,
    this.userRole,
  );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      int.parse(json['user_id'] ?? '0'),
      json['user_firstname'] ?? '',
      json['user_lastname'] ?? '',
      int.parse(json['phoneNumber'] ?? '0'),
      json['user_email'] ?? '',
      json['user_password'] ?? '',
      json['user_profileImage'] != null
          ? base64Decode(json['user_profileImage'])
          : null,
      json['user_registration_date'] ?? '',
      int.parse(json['role'] ?? '0'),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId.toString(),
        'user_firstname': userFirstName,
        'user_lastname': userLastName,
        'phoneNumber': userNumber.toString(),
        'user_email': userEmail,
        'user_password': userPassword,
        'user_profileImage': userProfileImageData != null
            ? base64Encode(userProfileImageData!)
            : null,
        'user_registration_date': userRegistrationDate,
        'role': userRole.toString(),
      };

  void updateUserProfileImageData(Uint8List? data) {
    userProfileImageData = data;
  }

  void updateUserInfoData(String? firstName, String? lastName, int? phone) {
    userFirstName = firstName ?? '';
    userLastName = lastName ?? '';
    userNumber = phone ?? 0;
  }
}
