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
      );

      final Map<String, dynamic> data = newSympton.toJson();

      final DocumentReference docRef = await symptonCollection.add(data);
      await docRef.update({'id': docRef.id});

      await docRef.collection("images1").add({
        'medicalReportImage': symptonModel.medicalReportImage,
        'doctorNoteImage': symptonModel.doctorNoteImage,
      });

      await docRef.collection("images2").add({
        'clinicNoteImage': symptonModel.clinicNoteImage,
        'precriptionsImage': symptonModel.precriptionsImage,
      });
    } catch (error) {
      print("error add symptons on servie: ${error}");
    }
  }

  Future<Map<String, dynamic>> getSymptomWithImages(
      String userId, String categoryId, String symptomId) async {
    try {
      // Reference to the symptom document
      final DocumentReference symptomDocRef = userCollection
          .doc(userId)
          .collection("healthCategory")
          .doc(categoryId)
          .collection("symptons")
          .doc(symptomId);

      // Fetch the main symptom document
      final DocumentSnapshot symptomDocSnapshot = await symptomDocRef.get();

      if (!symptomDocSnapshot.exists) {
        print("Symptom not found!");
        return {};
      }

      // Fetch `images1` subcollection
      final QuerySnapshot images1Snapshot =
          await symptomDocRef.collection("images1").get();

      // Fetch `images2` subcollection
      final QuerySnapshot images2Snapshot =
          await symptomDocRef.collection("images2").get();

      // Initialize image data
      String medicalReportImage = "";
      String doctorNoteImage = "";
      String clinicNoteImage = "";
      String prescriptionsImage = "";

      // Extract `images1` data
      if (images1Snapshot.docs.isNotEmpty) {
        final image1Doc = images1Snapshot.docs.first;
        medicalReportImage = image1Doc['medicalReportImage'] ?? "";
        doctorNoteImage = image1Doc['doctorNoteImage'] ?? "";
      }

      // Extract `images2` data
      if (images2Snapshot.docs.isNotEmpty) {
        final image2Doc = images2Snapshot.docs.first;
        clinicNoteImage = image2Doc['clinicNoteImage'] ?? "";
        prescriptionsImage = image2Doc['precriptionsImage'] ?? "";
      }

      // Combine all data
      return {
        'id': symptomDocSnapshot['id'],
        'name': symptomDocSnapshot['name'],
        'medicalReportImage': medicalReportImage,
        'doctorNoteImage': doctorNoteImage,
        'clinicNoteImage': clinicNoteImage,
        'prescriptionsImage': prescriptionsImage,
      };
    } catch (error) {
      print("Error fetching symptom with images: $error");
      return {};
    }
  }

}
