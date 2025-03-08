import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:healthcare/models/analytic_model.dart';
import 'package:healthcare/models/blood_suger_data_model.dart';

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

  Future<void> addAnalyticCategoryData(
      String userId, String categoryId, BloodSugerDataModel trackData) async {
    try {
      final CollectionReference analyticCategoryData = userCollection
          .doc(userId)
          .collection("analyticsCategory")
          .doc(categoryId)
          .collection("analyticsCategoryData");

      final Map<String, dynamic> data = trackData.toJson();
      await analyticCategoryData.add(data);
    } catch (error) {
      print("error adding data on service: ${error}");
    }
  }

  Future<void> deleteCategory(String userId, String categoryId) async {
    try {
      final DocumentReference categoryDoc = userCollection
          .doc(userId)
          .collection("analyticsCategory")
          .doc(categoryId);

      final categoryData =
          await categoryDoc.collection("analyticsCategoryData").get();

      for (final doc in categoryData.docs) {
        await doc.reference.delete();
      }
    } catch (error) {
      print("Error deleteting category on service: ${error}");
    }
  }
}
