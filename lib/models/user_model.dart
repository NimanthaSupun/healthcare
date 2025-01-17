import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final String jobTitle;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String password;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.jobTitle,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.password,
  });

  // convert to dart
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["userId"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      jobTitle: json["jobTitle"] ?? "",
      imageUrl: json["imageUrl"] ?? "",
      createdAt: (json["createdAt"] as Timestamp).toDate(),
      updatedAt: (json["updatedAt"] as Timestamp).toDate(),
      password: json["password"] ?? "",
    );
  }

  // todo: convert to json
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "name": name,
      "email": email,
      "jobTitle": jobTitle,
      "imageUrl": imageUrl,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "password": password,
    };
  }
}
