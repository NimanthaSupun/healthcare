import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare/models/clinic_model.dart';

class ClinicService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // Future<void> addNewClinic(
  //     String userId, String categoryId, Clinic clinic) async {
  //   try {
  //     final CollectionReference clinicCollection = userCollection
  //         .doc(userId)
  //         .collection("healthCategory")
  //         .doc(categoryId)
  //         .collection("clinc");

  //     final Map<String, dynamic> data = clinic.toJson();

  //     final DocumentReference docRef = await clinicCollection.add(data);
  //     await docRef.update({'id': docRef.id});
  //   } catch (error) {
  //     print("Error add Clinic on service: ${error}");
  //   }
  // }

  // todo: redesing for notification
  // Modified to return the clinic ID
  Future<String> addNewClinic(
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

      return docRef.id; // Return the generated document ID
    } catch (error) {
      print("Error add Clinic on service: ${error}");
      throw error; // Rethrow the error to handle it in the UI
    }
  }

  // todo: get Clinic as future

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
  // todo: get Clinic with their Categoty name
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

  // todo: delete Clinic
  Future<void> deleteClinic(
      String userId, String categoryId, String clinicId) async {
    try {
      await userCollection
          .doc(userId)
          .collection("healthCategory")
          .doc(categoryId)
          .collection("clinc")
          .doc(clinicId)
          .delete();
    } catch (error) {
      print("Error deleting Clinic on service: ${error}");
    }
  }

  // todo: update Clinic
  Future<void> updateClinic(
      String userId, String categoryId, String clinicId, Clinic clinic) async {
    try {
      await userCollection
          .doc(userId)
          .collection("healthCategory")
          .doc(categoryId)
          .collection("clinc")
          .doc(clinicId)
          .update(clinic.toJson());
    } catch (error) {
      print("error updating Clinic on service: ${error}");
    }
  }
}
