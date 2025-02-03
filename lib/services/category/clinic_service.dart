import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare/models/clinic_model.dart';

class ClinicService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addNewClinic(
      String userId, String categoryId, Clinic clinic) async {
    try {
      final CollectionReference clinicCollection = userCollection
          .doc(userId)
          .collection("healthCategory")
          .doc(categoryId)
          .collection("clinc");

      final Map<String, dynamic> data = clinic.toJson();

      final DocumentReference docRef = await clinicCollection.add(data);
      await docRef.update({'id': docRef.id});
    } catch (error) {
      print("Error add Clinic on service: ${error}");
    }
  }
}
