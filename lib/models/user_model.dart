import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String password;
  final String? sex;
  final int? heightFeet; // Store height in meters or centimeters
  final int? heightInches; // Store height in meters or centimeters
  final int? weight; // Store weight in kilograms
  final String? bloodGroup;
  final DateTime dateOfBirth;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.password,
    this.sex,
    this.heightFeet,
    this.weight,
    this.bloodGroup,
    this.heightInches,
    required this.dateOfBirth,
  });

  // convert to dart
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["userId"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      imageUrl: json["imageUrl"] ?? "",
      createdAt: (json["createdAt"] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json["updatedAt"] as Timestamp?)?.toDate() ?? DateTime.now(),
      password: json["password"] ?? "",
      sex: json["sex"] ?? "",
      heightFeet: (json["heightFeet"] as num?)?.toInt() ?? 0,
      heightInches: (json["heightInches"] as num?)?.toInt() ?? 0,
      weight: (json["weight"] as num?)?.toInt() ?? 0,
      bloodGroup: json["bloodGroup"] ?? "",
      dateOfBirth: (json["dateOfBirth"] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  get base64Image => null;

  // todo: convert to json
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "name": name,
      "email": email,
      "imageUrl": imageUrl,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "password": password,
      "sex": sex,
      "heightFeet": heightFeet,
      "heightInches": heightInches,
      "weight": weight,
      "bloodGroup": bloodGroup,
      "dateOfBirth": dateOfBirth,
    };
  }
}
