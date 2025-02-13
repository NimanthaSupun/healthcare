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
          id: "", name: symptonModel.name, dueDate: symptonModel.dueDate);

      final Map<String, dynamic> data = newSympton.toJson();

      final DocumentReference docRef = await symptonCollection.add(data);
      await docRef.update({'id': docRef.id});

      await docRef.collection("images1").add({
        'name': symptonModel.name,
        'medicalReportImage': symptonModel.medicalReportImage,
        'doctorNoteImage': symptonModel.doctorNoteImage,
      });

      await docRef.collection("images2").add({
        'name': symptonModel.name,
        'clinicNoteImage': symptonModel.clinicNoteImage,
        'precriptionsImage': symptonModel.precriptionsImage,
      });
    } catch (error) {
      print("error add symptons on servie: ${error}");
    }
  }

  // todo:---------------------------get All the sympto's with their category name------------------------------------------------------

  Stream<List<SymptonModel>> getSymptoms(String userId, String categoryId) {
    try {
      final CollectionReference symptonCollection = userCollection
          .doc(userId)
          .collection("healthCategory")
          .doc(categoryId)
          .collection("symptons");

      return symptonCollection.snapshots().asyncMap((snapshot) async {
        List<SymptonModel> symptoms = [];

        for (var doc in snapshot.docs) {
          // Get base symptom data
          Map<String, dynamic> symptomData = doc.data() as Map<String, dynamic>;
          String symptomId = doc.id;

          // Get images1 data
          var images1Snapshot = await doc.reference.collection('images1').get();
          var images1Data = images1Snapshot.docs.isNotEmpty
              ? images1Snapshot.docs.first.data()
              : {};

          // Get images2 data
          var images2Snapshot = await doc.reference.collection('images2').get();
          var images2Data = images2Snapshot.docs.isNotEmpty
              ? images2Snapshot.docs.first.data()
              : {};

          DateTime dueDate = (symptomData['dueDate'] as Timestamp).toDate();
          // Combine all data
          symptoms.add(SymptonModel(
            id: symptomId,
            name: symptomData['name'] ?? '',
            dueDate: dueDate,
            medicalReportImage: images1Data['medicalReportImage'] ?? '',
            doctorNoteImage: images1Data['doctorNoteImage'] ?? '',
            clinicNoteImage: images2Data['clinicNoteImage'] ?? '',
            precriptionsImage: images2Data['precriptionsImage'] ?? '',
          ));
        }

        return symptoms;
      });
    } catch (error) {
      print("Error getting symptoms: $error");
      return Stream.value([]);
    }
  }

  // Get all symptoms with their category names
  Future<Map<String, List<SymptonModel>>> getSymptomsWithCategoryName(
      String userId) async {
    try {
      final healthCategoryCollection =
          userCollection.doc(userId).collection("healthCategory");
      final QuerySnapshot categorySnapshot =
          await healthCategoryCollection.get();

      final Map<String, List<SymptonModel>> symptomMap = {};

      for (final doc in categorySnapshot.docs) {
        String categoryId = doc.id;
        String categoryName = doc['name'] ?? 'Unknown Category';

        // Get symptoms for this category
        final List<SymptonModel> symptoms =
            await getSymptoms(userId, categoryId).first;
        symptomMap[categoryName] = symptoms;
      }

      return symptomMap;
    } catch (error) {
      print("Error fetching symptoms with categories: $error");
      return {};
    }
  }

  // todo:update sympton category

  Future<void> updateSympton(String userId, String categoryId, String symptonId,
      SymptonModel symptonModel) async {
    try {
      final DocumentReference symptonDocRef = userCollection
          .doc(userId)
          .collection("healthCategory")
          .doc(categoryId)
          .collection("symptons")
          .doc(symptonId);

      // Update the symptom details
      await symptonDocRef.update({
        'name': symptonModel.name,
      });

      // Update images in the first collection (images1)
      final QuerySnapshot images1Snapshot =
          await symptonDocRef.collection("images1").get();
      if (images1Snapshot.docs.isNotEmpty) {
        final DocumentReference image1DocRef =
            images1Snapshot.docs.first.reference;
        await image1DocRef.update({
          'name': symptonModel.name,
          'medicalReportImage': symptonModel.medicalReportImage,
          'doctorNoteImage': symptonModel.doctorNoteImage,
        });
      }

      // Update images in the second collection (images2)
      final QuerySnapshot images2Snapshot =
          await symptonDocRef.collection("images2").get();
      if (images2Snapshot.docs.isNotEmpty) {
        final DocumentReference image2DocRef =
            images2Snapshot.docs.first.reference;
        await image2DocRef.update({
          'name': symptonModel.name,
          'clinicNoteImage': symptonModel.clinicNoteImage,
          'precriptionsImage': symptonModel.precriptionsImage,
        });
      }
    } catch (error) {
      print("error updating symptom: $error");
    }
  }

  // todo: Delete Sympton
  Future<void> deleteSympton(
      String userId, String categoryId, String symptonId) async {
    try {
      final DocumentReference symptonDocRef = userCollection
          .doc(userId)
          .collection("healthCategory")
          .doc(categoryId)
          .collection("symptons")
          .doc(symptonId);

      // Delete images in the first collection (images1)
      final QuerySnapshot images1Snapshot =
          await symptonDocRef.collection("images1").get();
      for (final doc in images1Snapshot.docs) {
        await doc.reference.delete();
      }

      // Delete images in the second collection (images2)
      final QuerySnapshot images2Snapshot =
          await symptonDocRef.collection("images2").get();
      for (final doc in images2Snapshot.docs) {
        await doc.reference.delete();
      }

      // Delete the symptom document
      await symptonDocRef.delete();
    } catch (error) {
      print("error deleting symptom: $error");
    }
  }
}
