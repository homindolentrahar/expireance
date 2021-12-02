import 'package:expireance/presentation/widgets/expire/expire_forms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpireSheets {
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
}
