import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/presentation/widgets/core/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DangerConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onPositive;
  final VoidCallback onNegative;

  const DangerConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onPositive,
    required this.onNegative,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      backgroundColor: Get.theme.canvasColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: Get.textTheme.headline5,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Get.textTheme.bodyText2?.copyWith(color: AppColor.gray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SecondaryButton.small(
                    title: "Cancel",
                    onPressed: onNegative,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PrimaryButton.small(
                    title: "Delete",
                    onPressed: onPositive,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
