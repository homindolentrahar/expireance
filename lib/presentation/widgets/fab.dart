import 'package:expireance/common/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FAB extends StatelessWidget {
  const FAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 0,
      height: 0,
      padding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      color: Get.theme.primaryColor,
      splashColor: Get.theme.canvasColor.withOpacity(0.15),
      highlightColor: Get.theme.canvasColor.withOpacity(0.15),
      elevation: 2,
      highlightElevation: 2,
      child: SvgPicture.asset(
        "assets/icons/plus.svg",
        color: AppColor.white,
        width: 48,
        height: 48,
      ),
      onPressed: () {},
    );
  }
}
