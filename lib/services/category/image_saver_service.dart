import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageService {
  static Future<void> saveBytes(List<int> bytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName.jpg');
    await file.writeAsBytes(bytes);
  }
}