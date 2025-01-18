import 'package:firebase_storage/firebase_storage.dart';

class UserProfileStorage {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadImage(
      {required profileImage, required userEmail}) async {
    try {
      Reference ref = _firebaseStorage
          .ref()
          .child('user-image')
          .child('$userEmail/${DateTime.now()}');

      UploadTask task = ref.putFile(
        profileImage,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      TaskSnapshot snapshot = await task;
      String url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (error) {
      print(error.toString());
      return "";
    }
  }

}
