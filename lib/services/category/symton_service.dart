import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare/models/sympton_model.dart';

class SymtonService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addNewSympton(
      String userId, String categoryId, SymptonModel symptonModel) async {
    try {
      final CollectionReference symptonCollection = userCollection
          .doc(userId)
          .collection("healthCategory")
          .doc(categoryId)
          .collection("symptons");

      final SymptonModel newSympton = SymptonModel(
        id: "",
        name: symptonModel.name,
        medicalReportImage: symptonModel.medicalReportImage,
        doctorNoteImage: symptonModel.doctorNoteImage,
        precriptionsImage: symptonModel.precriptionsImage,
        clinicNoteImage: symptonModel.clinicNoteImage,
      );

      final Map<String, dynamic> data = newSympton.toJson();

      final DocumentReference docRef = await symptonCollection.add(data);
      await docRef.update({'id': docRef.id});
    } catch (error) {
      print("error add symptons on servie: ${error}");
    }
  }
}
