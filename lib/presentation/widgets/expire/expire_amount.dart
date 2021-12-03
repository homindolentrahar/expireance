import 'dart:ui';

import 'package:expireance/common/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ExpireAmount extends StatelessWidget {
  final int value;
  final VoidCallback increase;
  final VoidCallback decrease;
  final ValueChanged<int> incrementalChange;

  const ExpireAmount({
    Key? key,
    required this.value,
    required this.increase,
    required this.decrease,
    required this.incrementalChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final incrementalAmounts = [5, 10, 25];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _AmountButton(
              enable: value > 1,
              icon: SvgPicture.asset(
                "assets/icons/minus.svg",
                color: value > 1 ? AppColor.white : AppColor.gray,
                width: 16,
                height: 16,
              ),
              onPressed: decrease,
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: value > 1 ? Get.theme.primaryColor : AppColor.light,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                value.toString(),
                style: Get.textTheme.bodyText2?.copyWith(
                  color: value > 1 ? Get.theme.canvasColor : AppColor.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Expanded(
            //   child: OutlinedField(
            //     // controller: TextEditingController(text: value.toString()),
            //     initialValue: value.toString(),
            //     name: "amount",
            //     textAlign: TextAlign.center,
            //     placeholder: "0",
            //     validators: [
            //       FormBuilderValidators.required(context),
            //       FormBuilderValidators.min(
            //         context,
            //         1,
            //         errorText: "Item cannot be empty",
            //       ),
            //     ],
            //     onChanged: (value) {
            //       if (value != null) {
            //         listenTyping(value);
            //       }
            //     },
            //   ),
            // ),
            const SizedBox(width: 16),
            _AmountButton(
              icon: SvgPicture.asset(
                "assets/icons/plus.svg",
                color: AppColor.white,
                width: 16,
                height: 16,
              ),
              onPressed: increase,
            ),
          ],
        ),
        value >= 5
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: incrementalAmounts
                        .map(
                          (amount) => _AmountChipIncremental(
                            onPressed: () => incrementalChange(amount),
                            text: "+$amount",
                          ),
                        )
                        .toList(),
                  )
                ],
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

class _AmountButton extends StatelessWidget {
  final bool enable;
  final Widget icon;
  final VoidCallback onPressed;

  const _AmountButton({
    Key? key,
    this.enable = true,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      disabledElevation: 0,
      minWidth: 0,
      height: 0,
      color: Get.theme.primaryColor,
      disabledColor: AppColor.light,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      padding: const EdgeInsets.all(4),
      child: icon,
      onPressed: enable ? onPressed : null,
    );
  }
}

class _AmountChipIncremental extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _AmountChipIncremental({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      minWidth: 0,
      height: 0,
      padding: const EdgeInsets.all(6),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: BorderSide(color: Get.theme.primaryColor)),
      color: Colors.transparent,
      splashColor: Get.theme.primaryColor.withOpacity(0.15),
      highlightColor: Get.theme.primaryColor.withOpacity(0.2),
      child: Text(
        text,
        style: Get.textTheme.bodyText2?.copyWith(
          color: Get.theme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
