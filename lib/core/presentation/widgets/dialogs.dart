import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/core/presentation/widgets/buttons.dart';
import 'package:flutter/material.dart';

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Theme.of(context).canvasColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColor.gray),
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
                    color: AppColor.red,
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
