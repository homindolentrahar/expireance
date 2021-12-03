import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/presentation/widgets/core/fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class ExpireAmount extends StatelessWidget {
  final int value;
  final VoidCallback increase;
  final VoidCallback decrease;
  final ValueChanged<String> listenTyping;

  const ExpireAmount({
    Key? key,
    required this.value,
    required this.increase,
    required this.decrease,
    required this.listenTyping,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
        Expanded(
          child: OutlinedField(
            controller: TextEditingController(text: value.toString()),
            name: "amount",
            textAlign: TextAlign.center,
            placeholder: "0",
            validators: [
              FormBuilderValidators.required(context),
              FormBuilderValidators.min(
                context,
                1,
                errorText: "Item cannot be empty",
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                listenTyping(value);
              }
            },
          ),
        ),
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
