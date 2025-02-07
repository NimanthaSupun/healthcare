import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';

class ImageService {
  static final Dio _dio = Dio();
  
  static Future<String?> saveImage(String imageUrl, String imageName) async {
    try {
      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        throw 'Storage permission denied';
      }

      // Get the directory
      final directory = await _getDirectory();
      if (directory == null) return null;

      // Download and save image
      final fileName = '${imageName}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${directory.path}/$fileName';

      final response = await _dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final file = File(filePath);
      await file.writeAsBytes(response.data);

      // Notify media scanner (Android only)
      if (Platform.isAndroid) {
        await _scanFile(filePath);
      }

      return filePath;
    } catch (e) {
      print('Error saving image: $e');
      return null;
    }
  }

  static Future<Directory?> _getDirectory() async {
    if (Platform.isAndroid) {
      // For Android, save to Pictures directory
      final directory = Directory('/storage/emulated/0/Pictures');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      return directory;
    } else {
      // For iOS, save to application documents directory
      return await getApplicationDocumentsDirectory();
    }
  }

  static Future<void> _scanFile(String filePath) async {
    try {
      // This is a workaround to make the image appear in gallery
      await File(filePath).setLastModified(DateTime.now());
    } catch (e) {
      print('Error scanning file: $e');
    }
  }
}