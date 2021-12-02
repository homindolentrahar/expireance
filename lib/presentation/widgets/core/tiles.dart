import 'package:expireance/common/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IconTiles extends StatelessWidget {
  final Widget icon;
  final String title;
  final TextStyle? textStyle;
  final VoidCallback onTap;

  const IconTiles({
    Key? key,
    required this.icon,
    required this.title,
    this.textStyle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColor.light,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 16),
              Text(
                title,
                style: textStyle ??
                    Get.textTheme.bodyText2?.copyWith(color: AppColor.dark),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TextTiles extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const TextTiles({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColor.light,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            title,
            style: Get.textTheme.bodyText2?.copyWith(
              color: AppColor.dark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
