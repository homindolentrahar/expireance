import 'package:expireance/common/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Loading {
  static LoadingIndicator load() {
    return const LoadingIndicator(
      indicatorType: Indicator.ballRotateChase,
      colors: [AppColor.black],
      strokeWidth: 2,
      backgroundColor: Colors.transparent,
      pathBackgroundColor: Colors.transparent,
    );
  }
}
