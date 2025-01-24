import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare/models/blood_suger_data_model.dart';

class HealthTrackerService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> saveTrackData(
      String userId, BloodSugerDataModel trackData) async {
    try {
      final CollectionReference trackUserDataCollection =
          userCollection.doc(userId).collection("bloodSugarData");

      final Map<String, dynamic> data = trackData.toJson();

      await trackUserDataCollection.add(data);
    } catch (error) {
      print("error ons service: ${error}");
    }
  }

  Stream<List<BloodSugerDataModel>> getBloodSugerData(String userId) {
    try {
      final CollectionReference trackUserDataCollection =
          userCollection.doc(userId).collection("bloodSugarData");

      return trackUserDataCollection.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => BloodSugerDataModel.fromJson(
                doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (error) {
      print("Error: ${error}");
      return Stream.empty();
    }
  }
}
