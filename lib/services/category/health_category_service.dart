import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare/models/health_category_model.dart';

class HealthCategoryService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createNewCateGory(String userId, HealthCategory category) async {
    try {
      final CollectionReference healthCategory =
          userCollection.doc(userId).collection("healthCategory");

      final HealthCategory newCategory = HealthCategory(
        id: "",
        name: category.name,
        description: category.description,
      );

      final Map<String, dynamic> data = newCategory.toJson();

      DocumentReference docRef = await healthCategory.add(data);

      await docRef.update({'id': docRef.id});
    } catch (error) {
      print("Error creating category on service");
    }
  }

  // todo: get healthcategory as Streeam
  Stream<List<HealthCategory>> healthCategories(String userId) {
    try {
      final CollectionReference healthCategory =
          userCollection.doc(userId).collection("healthCategory");

      return healthCategory.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) =>
                HealthCategory.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (error) {
      print("Error fetching category on service: $error");
      return Stream.empty();
    }
  }

  // todo: get health category as Future
  Future<List<HealthCategory>> getHealthCategories(String userId) async {
    try {
      final CollectionReference healthCategory =
          userCollection.doc(userId).collection("healthCategory");

      final QuerySnapshot snapshot = await healthCategory.get();

      return snapshot.docs.map((doc) {
        return HealthCategory.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (error) {
      print("Error feching category on service: $error");
      return [];
    }
  }

  // todo: delete health category as Future
  Future<void> deleteHealthCategory(
      String userId, String healthCategoryId) async {
    try {
      await userCollection
          .doc(userId)
          .collection("healthCategory")
          .doc(healthCategoryId)
          .delete();
    } catch (error) {
      print("Error deleting category on service: $error");
    }
  }

  // todo: delete healthcategory with their subcollection

  Future<void> deleteHealthCategoryWithSubCollection(
      String userId, String healthCategoryId) async {
    try {
      //`todo:- Get reference to the health category document
      final categoryDoc = userCollection
          .doc(userId)
          .collection("healthCategory")
          .doc(healthCategoryId);

      //todo:- 1. Delete all symptoms and their subcollections
      final symptonSnapshot = await categoryDoc.collection("symptons").get();
      for (var symptonDoc in symptonSnapshot.docs) {
        // Delete images1 collection for this symptom
        final images1Snapshot =
            await symptonDoc.reference.collection("images1").get();
        for (var imageDoc in images1Snapshot.docs) {
          await imageDoc.reference.delete();
        }

        // Delete images2 collection for this symptom
        final images2Snapshot =
            await symptonDoc.reference.collection("images2").get();
        for (var imageDoc in images2Snapshot.docs) {
          await imageDoc.reference.delete();
        }

        // Delete the symptom document itself
        await symptonDoc.reference.delete();
      }

      // 2. Delete all clinics
      final clinicSnapshot = await categoryDoc.collection("clinc").get();
      for (var clinicDoc in clinicSnapshot.docs) {
        await clinicDoc.reference.delete();
      }

      // 3. Finally delete the health category document
      await categoryDoc.delete();
    } catch (error) {
      print("Error deleting category on service: $error");
      rethrow;
    }
  }

  // todo: update healthCategory
  Future<void> updateHealthCategory(
      String userId, String categoryId, HealthCategory healthCategory) async {
    try {
      await userCollection
          .doc(userId)
          .collection("healthCategory")
          .doc(categoryId)
          .update(healthCategory.toJson());
    } catch (error) {
      print("Error updating category on service");
    }
  }
}
