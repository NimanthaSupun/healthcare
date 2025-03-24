import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare/models/analytic_model.dart';
import 'package:healthcare/models/blood_suger_data_model.dart';

class AnalyticCategoryService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

// todo: Create analytic category service
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
// todo: delete Category
 Future<void> deleteCategory(String userId, String categoryId) async {
  try {
    final DocumentReference categoryDoc = userCollection
        .doc(userId)
        .collection("analyticsCategory")
        .doc(categoryId);

    // First, delete all documents in the subcollection
    final categoryData =
        await categoryDoc.collection("analyticsCategoryData").get();

    for (final doc in categoryData.docs) {
      await doc.reference.delete();
    }
    
    // Then delete the category document itself
    await categoryDoc.delete();
    
  } catch (error) {
    print("Error deleting category on service: ${error}");
  }
}
// todo: get analytic category as stream
  Stream<List<BloodSugerDataModel>> getAnalyticData(
      String userId, String categoryId) {
    try {
      final CollectionReference analyticCategoryData = userCollection
          .doc(userId)
          .collection("analyticsCategory")
          .doc(categoryId)
          .collection("analyticsCategoryData");

      return analyticCategoryData.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => BloodSugerDataModel.fromJson(
                doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (error) {
      print("error fetching data as Streem: ${error}");
      return Stream.empty();
    }
  }

  Future<Map<String, List<BloodSugerDataModel>>> getAnalyticDataByCategoryName(
      String userId) async {
    try {
      final QuerySnapshot snapshot = await userCollection
          .doc(userId)
          .collection('analyticsCategory')
          .get();

      final Map<String, List<BloodSugerDataModel>> dataMap = {};

      for (final doc in snapshot.docs) {
        String categoryId = doc.id;

        final List<BloodSugerDataModel> data =
            await getAnalyticData(userId, categoryId).first;

        dataMap[doc['name']] = data;
      }
      return dataMap;
    } catch (error) {
      print("Error: ${error}");
      return {};
    }
  }

  Future<List<AnalyticModel>> getAnalyticCategoryAsFuture(String userId) async {
    try {
      final QuerySnapshot snapshot = await userCollection
          .doc(userId)
          .collection('analyticsCategory')
          .get();

      return snapshot.docs.map((doc) {
        return AnalyticModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (error) {
      print("error: ${error}");
      return [];
    }
  }
}
