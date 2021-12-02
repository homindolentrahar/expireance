import 'package:expireance/common/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExpireDate extends StatelessWidget {
  final DateTime? date;
  final VoidCallback showDate;

  const ExpireDate({
    Key? key,
    required this.date,
    required this.showDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _PickerButton(
          onPressed: showDate,
        ),
        const SizedBox(width: 4),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Expire Date:",
              style: TextStyle(
                color: AppColor.gray,
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              date == null ? "Not Selected" : DateFormat.yMMMd().format(date!),
              style: Get.textTheme.bodyText2?.copyWith(
                color: AppColor.dark,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PickerButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _PickerButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      minWidth: 0,
      height: 0,
      color: Get.theme.primaryColor,
      padding: const EdgeInsets.all(4),
      child: SvgPicture.asset(
        "assets/icons/date.svg",
        width: 16,
        height: 16,
        color: AppColor.white,
      ),
      onPressed: onPressed,
    );
  }
}
