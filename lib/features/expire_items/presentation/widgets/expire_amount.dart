import 'package:expireance/common/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                color:
                    value > 1 ? Theme.of(context).primaryColor : AppColor.light,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                value.toString(),
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: value > 1
                          ? Theme.of(context).canvasColor
                          : AppColor.dark,
                      fontWeight: FontWeight.bold,
                    ),
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
      color: Theme.of(context).primaryColor,
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
          side: BorderSide(color: Theme.of(context).primaryColor)),
      color: Colors.transparent,
      splashColor: Theme.of(context).primaryColor.withOpacity(0.15),
      highlightColor: Theme.of(context).primaryColor.withOpacity(0.2),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText2?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
      ),
      onPressed: onPressed,
    );
  }
}
