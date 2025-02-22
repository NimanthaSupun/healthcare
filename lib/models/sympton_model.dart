import 'package:cloud_firestore/cloud_firestore.dart';

class SymptonModel {
  final String id;
  final String name;
  final String? medicalReportImage;
  final String? doctorNoteImage;
  final String? precriptionsImage;
  final String? clinicNoteImage;
  final String? medicalProccessText;
  final String? doctorProcessText;
  final String? precriptionsProcessText;
  final String? clinicalProccessText;
  final DateTime dueDate;

  SymptonModel({
    required this.id,
    required this.name,
    this.medicalReportImage,
    this.doctorNoteImage,
    this.precriptionsImage,
    this.clinicNoteImage,
    required this.dueDate,
    this.medicalProccessText,
    this.doctorProcessText,
    this.precriptionsProcessText,
    this.clinicalProccessText,
  });

  // convert to dart
  factory SymptonModel.fromJson(Map<String, dynamic> json) {
    return SymptonModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      medicalReportImage: json['medicalReportImage'] ?? '',
      doctorNoteImage: json['doctorNoteImage'] ?? '',
      precriptionsImage: json['precriptionsImage'] ?? '',
      clinicNoteImage: json['clinicNoteImage'] ?? '',
      dueDate: (json['dueDate'] as Timestamp).toDate(),
      medicalProccessText:json['medicalProccessText'] ?? '',
      doctorProcessText:json['doctorProcessText'] ?? '',
      precriptionsProcessText:json['precriptionsProcessText'] ?? '',
      clinicalProccessText:json['clinicalProccessText'] ?? ','
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'medicalReportImage': medicalReportImage,
      'doctorNoteImage': doctorNoteImage,
      'precriptionsImage': precriptionsImage,
      'clinicNoteImage': clinicNoteImage,
      'dueDate': Timestamp.fromDate(dueDate),
      'medicalProccessText':medicalProccessText,
      'doctorProcessText':doctorProcessText,
      'precriptionsProcessText':precriptionsProcessText,
      'clinicalProccessText':clinicalProccessText,
    };
  }
}
