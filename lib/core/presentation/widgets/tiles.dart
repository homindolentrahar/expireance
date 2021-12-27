import 'package:expireance/common/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                    Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(color: AppColor.dark),
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
  final bool selected;
  final VoidCallback onTap;

  const TextTiles({
    Key? key,
    required this.title,
    this.selected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Theme.of(context).primaryColor : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColor.light,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              selected
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/check.svg",
                          width: 24,
                          height: 24,
                          color: AppColor.white,
                        ),
                        const SizedBox(width: 8),
                      ],
                    )
                  : const SizedBox.shrink(),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: selected
                          ? Theme.of(context).canvasColor
                          : Theme.of(context).primaryColor,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
