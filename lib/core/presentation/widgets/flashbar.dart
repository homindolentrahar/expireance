import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:expireance/common/theme/app_color.dart';

enum FlashbarType { SUCCESS, ERROR }

class Flashbar {
  final BuildContext _context;
  final String _title;
  final String _content;
  final int _secondDuration;
  final FlashbarType _type;

  Flashbar({
    required BuildContext context,
    required String title,
    required String content,
    int secondDuration = 3,
    required FlashbarType type,
  })  : _context = context,
        _title = title,
        _content = content,
        _secondDuration = secondDuration,
        _type = type;

  void flash() {
    showFlash(
      context: _context,
      duration: Duration(seconds: _secondDuration),
      builder: (ctx, controller) => Flash(
        controller: controller,
        barrierBlur: 0.0,
        behavior: FlashBehavior.floating,
        position: FlashPosition.top,
        backgroundColor: AppColor.black,
        margin: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(16),
        forwardAnimationCurve: Curves.easeInQuint,
        reverseAnimationCurve: Curves.easeOutQuint,
        child: FlashBar(
          icon: SvgPicture.asset(
            _type == FlashbarType.SUCCESS
                ? "assets/icons/success.svg"
                : "assets/icons/error.svg",
            color:
                _type == FlashbarType.SUCCESS ? AppColor.green : AppColor.red,
          ),
          title: Text(
            _title,
            style: Theme.of(_context)
                .textTheme
                .headline5
                ?.copyWith(color: AppColor.white),
          ),
          content: Text(
            _content,
            style: Theme.of(_context)
                .textTheme
                .bodyText2
                ?.copyWith(color: AppColor.gray),
          ),
          padding: const EdgeInsets.all(20),
        ),
      ),
    );
  }
}
