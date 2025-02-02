class SymptonModel {
  final String name;
  final String? medicalReportImage;
  final String? doctorNameImage;
  final String? precriptionsImage;
  final String? clinicNoteImage;

  SymptonModel({
    required this.name,
    this.medicalReportImage,
    this.doctorNameImage,
    this.precriptionsImage,
    this.clinicNoteImage,
  });
}
