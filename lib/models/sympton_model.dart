class SymptonModel {
  final String name;
  final String? medicalReportImage;
  final String? doctorNoteImage;
  final String? precriptionsImage;
  final String? clinicNoteImage;

  SymptonModel({
    required this.name,
    this.medicalReportImage,
    this.doctorNoteImage,
    this.precriptionsImage,
    this.clinicNoteImage,
  });

  // convert to dart
  factory SymptonModel.fromJson(Map<String, dynamic> json) {
    return SymptonModel(
      name: json['name'] ?? '',
      medicalReportImage: json['medicalReportImage'] ?? '',
      doctorNoteImage: json['doctorNoteImage'] ?? '',
      precriptionsImage: json['precriptionsImage'] ?? '',
      clinicNoteImage: json['clinicNoteImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'medicalReportImage': medicalReportImage,
      'doctorNoteImage': doctorNoteImage,
      'precriptionsImage': precriptionsImage,
      'clinicNoteImage': clinicNoteImage,
    };
  }
}
