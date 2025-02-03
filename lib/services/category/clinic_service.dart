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

  // todo: get Clinic with category name

  // get Clinic

  Stream<List<Clinic>> getClinic(String userId, String categoryId) {
    try {
      final CollectionReference clinicCollection = userCollection
          .doc(userId)
          .collection("healthCategory")
          .doc(categoryId)
          .collection("clinc");

      return clinicCollection.snapshots().map((snpshot) {
        return snpshot.docs
            .map((doc) => Clinic.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (error) {
      print("error: ${error}");
      return Stream.empty();
    }
  }

  Future<Map<String, List<Clinic>>> getClinicWithCategoryName(
      String userId) async {
    try {
      final healthCategoryCollection =
          userCollection.doc(userId).collection("healthCategory");

      final QuerySnapshot snapshot = await healthCategoryCollection.get();

      final Map<String, List<Clinic>> clinicMap = {};

      for (final doc in snapshot.docs) {
        final categoryId = doc.id;

        final List<Clinic> clincs = await getClinic(userId, categoryId).first;
        clinicMap[doc['name']] = clincs;
      }
      return clinicMap;
    } catch (error) {
      print("Error fetching clinic map onservice: ${error}");
      return {};
    }
  }
}
