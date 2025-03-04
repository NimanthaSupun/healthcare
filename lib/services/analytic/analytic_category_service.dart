import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare/models/analytic_model.dart';

class AnalyticCategoryService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createCategory(
      String userId, AnalyticModel analyticModel) async {
    try {
      final CollectionReference analyticCollection =
          userCollection.doc(userId).collection('analyticsCategory');

      final Map<String, dynamic> data = analyticModel.toJson();

      DocumentReference docRec = await analyticCollection.add(data);
      await docRec.update({'id': docRec.id});
    } catch (error) {
      print("error create Analytic on service");
    }
  }

  Stream<List<AnalyticModel>> getAnalyticCategory(String userId) {
    try {
      final CollectionReference analyticCollection =
          userCollection.doc(userId).collection('analyticsCategory');

      return analyticCollection.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) =>
                AnalyticModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (error) {
      print("Error Fetching data: ${error}");
      return Stream.empty();
    }
  }
}
