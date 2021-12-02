import 'package:flash/flash.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
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
        borderRadius: BorderRadius.circular(2.0),
        forwardAnimationCurve: Curves.easeInQuint,
        reverseAnimationCurve: Curves.easeOutQuint,
        child: FlashBar(
          icon: Icon(
            _type == FlashbarType.SUCCESS
                ? Ionicons.checkmark_circle
                : Ionicons.remove_circle,
            color:
                _type == FlashbarType.SUCCESS ? AppColor.green : AppColor.red,
          ),
          title: Text(
            _title,
            style: Get.textTheme.headline5?.copyWith(color: AppColor.white),
          ),
          content: Text(
            _content,
            style: Get.textTheme.bodyText2?.copyWith(color: AppColor.dark),
          ),
          padding: const EdgeInsets.all(20),
        ),
      ),
    );
  }
}
