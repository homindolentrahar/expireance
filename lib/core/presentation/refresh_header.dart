import 'package:expireance/common/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshHeader extends StatelessWidget {
  const RefreshHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClassicHeader(
      refreshStyle: RefreshStyle.Follow,
      idleIcon: SvgPicture.asset(
        "assets/icons/cloud-download.svg",
        color: AppColor.dark,
      ),
      idleText: "",
      releaseIcon: SvgPicture.asset(
        "assets/icons/cloud-download.svg",
        color: AppColor.dark,
      ),
      releaseText: "",
      refreshingIcon: SvgPicture.asset(
        "assets/icons/cloud-download.svg",
        color: AppColor.dark,
      ),
      refreshingText: "",
      completeIcon: SvgPicture.asset(
        "assets/icons/cloud-success.svg",
        color: AppColor.dark,
      ),
      completeText: "",
      failedIcon: SvgPicture.asset(
        "assets/icons/cloud-error.svg",
        color: AppColor.dark,
      ),
      failedText: "",
      textStyle: Get.textTheme.bodyText2!.copyWith(color: AppColor.gray),
    );
  }
}
