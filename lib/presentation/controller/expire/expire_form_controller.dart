import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ExpireFormController extends GetxController {
  final Rx<String> _imageObs = "".obs;
  final Rx<int> _amountObs = 1.obs;
  final Rx<String> _categoryObs = "".obs;
  final Rx<String> _expiredDateObs = "".obs;

  final Rx<bool> _runValidation = false.obs;
  Map<String, String> errorMessages = {};

  String get imageObs => _imageObs.value;

  int get amountObs => _amountObs.value;

  String get categoryObs => _categoryObs.value;

  String get expiredDateObs => _expiredDateObs.value;

  //  Validation
  bool get runValidation => _runValidation.value;

  bool get categoryValid => categoryObs.isNotEmpty;

  bool get expiredDateValid => expiredDateObs.isNotEmpty;

  Future<void> setImage(ImageSource source) async {
    final imagePicker = Get.find<ImagePicker>();
    final image = await imagePicker.pickImage(source: source);

    if (image == null) {
      _imageObs.value = "";
    } else {
      final path = (await getApplicationDocumentsDirectory()).path;
      File imageFile = await File(image.path).copy(
        "$path/${image.name}",
      );

      _imageObs.value = imageFile.path;
    }
  }

  void clearImage() {
    _imageObs.value = "";
  }

  void setAmount(int amount) {
    _amountObs.value = amount;
  }

  void setCategory(String id) {
    _categoryObs.value = id;
  }

  void setExpiredDate(DateTime expired) {
    _expiredDateObs.value = expired.toIso8601String();
  }

  void clearExpiredDate() {
    _expiredDateObs.value = "";
  }

  void setRunValidation(bool runValidation) {
    _runValidation.value = runValidation;
  }
}
