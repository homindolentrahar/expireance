import 'package:expireance/features/expire_items/presentation/widgets/expire_forms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpireFormsSheet {
  static void addExpireItem() {
    Get.bottomSheet(
      const AddExpireForm(),
      backgroundColor: Get.theme.canvasColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(2),
          topRight: Radius.circular(2),
        ),
      ),
    );
  }

  static void updateExpireItem(String id) {
    Get.bottomSheet(
      UpdateExpireForm(id: id),
      backgroundColor: Get.theme.canvasColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(2),
          topRight: Radius.circular(2),
        ),
      ),
    );
  }
}
