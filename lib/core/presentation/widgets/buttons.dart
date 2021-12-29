import 'package:expireance/common/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_route/auto_route.dart';

class PlainBackButton extends StatelessWidget {
  const PlainBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.pop(),
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
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: SvgPicture.asset(
        "assets/icons/sort.svg",
        width: 16,
        height: 16,
        color: Theme.of(context).canvasColor,
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        splashColor: AppColor.red.withOpacity(0.25),
        highlightColor: AppColor.red.withOpacity(0.35),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColor.red.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(
            "assets/icons/delete.svg",
            width: 16,
            height: 16,
            color: AppColor.red,
          ),
        ),
      ),
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
      color: Theme.of(context).primaryColor,
      splashColor: Theme.of(context).canvasColor.withOpacity(0.15),
      highlightColor: Theme.of(context).canvasColor.withOpacity(0.15),
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
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      padding: EdgeInsets.all(padding),
      child: Text(
        title,
        style: Theme.of(context).textTheme.button?.copyWith(
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
      color: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1.3,
        ),
      ),
      padding: EdgeInsets.all(padding),
      child: Text(
        title,
        style: Theme.of(context).textTheme.button?.copyWith(
            color: Theme.of(context).primaryColor, fontSize: fontSize),
      ),
      onPressed: onPressed,
    );
  }
}

class TextualButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final double fontSize;
  final Color? splashColor;
  final VoidCallback onTap;

  const TextualButton({
    Key? key,
    required this.text,
    this.textColor = AppColor.black,
    this.fontSize = 14,
    this.splashColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: splashColor,
      borderRadius: BorderRadius.circular(2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class IconBackButton extends StatelessWidget {
  final VoidCallback? followedAction;

  const IconBackButton({
    Key? key,
    this.followedAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.router.pop();

        followedAction?.call();
      },
      icon: SvgPicture.asset(
        "assets/icons/back.svg",
        width: 24,
        height: 24,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

class IconAddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const IconAddButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        "assets/icons/plus.svg",
        width: 24,
        height: 24,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

class IconHamburgerButton extends StatelessWidget {
  const IconHamburgerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
      icon: SvgPicture.asset(
        "assets/icons/hamburger.svg",
        width: 20,
        height: 20,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
