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

  // get symptons
  Stream<List<SymptonModel>> getSympton(String userId, String categoryId) {
    try {
      final CollectionReference symptonCollection = userCollection
          .doc(userId)
          .collection("healthCategory")
          .doc(categoryId)
          .collection("symptons");

      return symptonCollection.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) =>
                SymptonModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (error) {
      print("Error fetch Symptons: ${error}");
      return Stream.empty();
    }
  }

  // Future<void> updateSymton(
  //     String userId, String categoryId, SymptonModel symptonModel) async {
  //   try {
  //     final CollectionReference symptonCollection = userCollection
  //         .doc(userId)
  //         .collection("healthCategory")
  //         .doc(categoryId)
  //         .collection("symptons");
  //   } catch (error) {
  //     print("error update symptons on servie: ${error}");
  //   }
  // }
}
