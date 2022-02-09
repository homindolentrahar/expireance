import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class ImageUtils {
  static Future<bool> checkIfImageExists(String name) async {
    final dirPath = (await getApplicationDocumentsDirectory()).path;
    return File("$dirPath/$name").exists();
  }

  static Future<File> storeImageToDevice(String imagePath, String name) async {
    final dirPath = (await getApplicationDocumentsDirectory()).path;
    return File(imagePath).copy("$dirPath/$name");
  }

  static Future<File> updateImageAtDevice(
    String imagePath,
    String previousName,
    String newName,
  ) async {
    final dirPath = (await getApplicationDocumentsDirectory()).path;

    if (await checkIfImageExists(previousName)) {
      File("$dirPath/$previousName").delete();
    }
    return File(imagePath).copy("$dirPath/$newName");
  }

  static Future<void> deleteImageFromDevice(String name) async {
    final dirPath = (await getApplicationDocumentsDirectory()).path;

    if (await checkIfImageExists(name)) {
      await File("$dirPath/$name").delete();
    }
  }
}
