import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthcare/models/user_model.dart';
import 'package:healthcare/services/auth/auth_service.dart';

class UserService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> saveUser(UserModel user) async {
    try {
      final UserCredential userCredential =
          await AuthService().createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      final userId = userCredential.user?.uid;

      if (userId != null) {
        final userRef = userCollection.doc(userId);

        final userMap = user.toJson();
        userMap['userId'] = userId;

        await userRef.set(userMap);
        print("user saved successfully with ID: $userId");
      } else {
        print("Error: user Id is null");
      }
    } catch (error) {
      print("Error saving user: $error");
    }
  }

  // get userBy id
  //get user details by id
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await userCollection.doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (error) {
      print('Error getting user: $error');
    }
    return null;
  }


  // update User
  Future<void> updateUser(String userId, UserModel updateUser) async {
    try {
      final Map<String, dynamic> updateJsonUser = updateUser.toJson();
      await userCollection.doc(userId).update(updateJsonUser);
    } catch (error) {
      print("Error updating user on service: ${error}");
    }
  }
}
