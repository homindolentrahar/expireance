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

class SortButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SortButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 0,
      height: 0,
      elevation: 0,
      highlightElevation: 0,
      padding: const EdgeInsets.all(4),
      color: Get.theme.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: SvgPicture.asset(
        "assets/icons/sort.svg",
        width: 16,
        height: 16,
        color: Get.theme.canvasColor,
      ),
      onPressed: onPressed,
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
  final double padding;
  final double fontSize;
  final VoidCallback onPressed;

  const PrimaryButton({
    Key? key,
    required this.title,
    this.width = double.infinity,
    this.padding = 16,
    this.fontSize = 16,
    required this.onPressed,
  }) : super(key: key);

  factory PrimaryButton.small({
    required String title,
    required VoidCallback onPressed,
  }) =>
      PrimaryButton(
        title: title,
        fontSize: 14,
        onPressed: onPressed,
      );

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: width,
      height: 0,
      elevation: 0,
      highlightElevation: 0,
      color: Get.theme.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      padding: EdgeInsets.all(padding),
      child: Text(
        title,
        style: Get.textTheme.button?.copyWith(
          color: AppColor.white,
          fontSize: fontSize,
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String title;
  final double width;
  final double padding;
  final double fontSize;
  final VoidCallback onPressed;

  const SecondaryButton({
    Key? key,
    required this.title,
    this.width = double.infinity,
    this.padding = 16,
    this.fontSize = 16,
    required this.onPressed,
  }) : super(key: key);

  factory SecondaryButton.small({
    required String title,
    required VoidCallback onPressed,
  }) =>
      SecondaryButton(
        title: title,
        fontSize: 14,
        onPressed: onPressed,
      );

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: width,
      height: 0,
      elevation: 0,
      highlightElevation: 0,
      color: Get.theme.canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
        side: BorderSide(
          color: Get.theme.primaryColor,
          width: 1.3,
        ),
      ),
      padding: EdgeInsets.all(padding),
      child: Text(
        title,
        style: Get.textTheme.button
            ?.copyWith(color: Get.theme.primaryColor, fontSize: fontSize),
      ),
      onPressed: onPressed,
    );
  }
}
