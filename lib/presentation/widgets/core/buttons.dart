import 'package:expireance/common/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PlainBackButton extends StatelessWidget {
  const PlainBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: SvgPicture.asset(
        "assets/icons/back.svg",
        color: AppColor.black,
        width: 24,
        height: 24,
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DeleteButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 0,
      height: 0,
      elevation: 0,
      highlightElevation: 0,
      color: AppColor.red.withOpacity(0.15),
      padding: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: SvgPicture.asset(
        "assets/icons/delete.svg",
        width: 16,
        height: 16,
        color: AppColor.red,
      ),
      onPressed: onPressed,
    );
  }
}

class FAB extends StatelessWidget {
  final VoidCallback onPressed;

  const FAB({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

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
      onPressed: onPressed,
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String title;
  final double width;
  final VoidCallback onPressed;

  const PrimaryButton({
    Key? key,
    required this.title,
    this.width = double.infinity,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: width,
      height: 0,
      elevation: 0,
      highlightElevation: 0,
      color: Get.theme.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: Get.textTheme.button?.copyWith(
          color: AppColor.white,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
