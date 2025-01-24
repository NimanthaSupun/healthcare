import 'package:cloud_firestore/cloud_firestore.dart';

class BloodSugerDataModel {
  
  final DateTime date;
  final double sugerLevel;
  final String? notes;

  BloodSugerDataModel({
    required this.date,
    required this.sugerLevel,
    this.notes,
  });

  factory BloodSugerDataModel.fromJson(Map<String, dynamic> json) {
    return BloodSugerDataModel(
      date: (json['date'] as Timestamp).toDate(),
      sugerLevel: json['sugerLevel'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sugerLevel': sugerLevel,
      'date': date,
      'notes':notes,
    };
  }
}
