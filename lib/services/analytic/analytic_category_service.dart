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

      final DocumentReference docRec = await analyticCollection.add(data);
      await docRec.update({'id': docRec.id});
    } catch (error) {
      print("error create Analytic on service");
    }
  }
}
