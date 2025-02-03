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
      print("Error fetching category on service: ${error}");
      return Stream.empty();
    }
  }
}
