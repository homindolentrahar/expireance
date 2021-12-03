import 'dart:io';

import 'package:expireance/domain/models/expire_item_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ExpireFormController extends GetxController {
  final Rx<String> _imageObs = "".obs;
  final Rx<String> _nameObs = "".obs;
  final Rx<int> _amountObs = 1.obs;
  final Rx<String> _categoryObs = "".obs;
  final Rx<String> _descObs = "".obs;
  final Rx<String> _expiredDateObs = "".obs;

  final Rx<bool> _runValidation = false.obs;
  Map<String, String> errorMessages = {};

  String get imageObs => _imageObs.value;

  String get nameObs => _nameObs.value;

  int get amountObs => _amountObs.value;

  String get categoryObs => _categoryObs.value;

  String get descObs => _descObs.value;

  String get expiredDateObs => _expiredDateObs.value;

  //  Validation
  bool get runValidation => _runValidation.value;

  bool get categoryValid => categoryObs.isNotEmpty;

  bool get expiredDateValid => expiredDateObs.isNotEmpty;

  void populateInitialData(ExpireItemModel? model) {
    _imageObs.value = model?.image ?? "";
    _nameObs.value = model?.name ?? "";
    _amountObs.value = model?.amount ?? 1;
    _categoryObs.value = model?.categoryId ?? "";
    _descObs.value = model?.desc ?? "";
    _expiredDateObs.value = model?.date.toIso8601String() ?? "";
  }

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

  void setName(String value) {
    _nameObs.value = value;
  }

  void setAmount(int amount) {
    _amountObs.value = amount;
  }

  void setCategory(String id) {
    _categoryObs.value = id;
  }

  void setDesc(String value) {
    _descObs.value = value;
  }

  void setExpiredDate(DateTime expired) {
    _expiredDateObs.value = expired.toIso8601String();
  }

  void setRunValidation(bool runValidation) {
    _runValidation.value = runValidation;
  }
}
