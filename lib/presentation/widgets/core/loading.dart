import 'package:expireance/common/theme/app_color.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Loading {
  static void load() {
    Get.dialog(
      SizedBox(
        width: 32,
        height: 32,
        child: WillPopScope(
          onWillPop: () async => false,
          child: const SpinKitSquareCircle(
            color: AppColor.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
