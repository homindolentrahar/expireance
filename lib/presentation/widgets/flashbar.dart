import 'package:flash/flash.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:expireance/common/theme/app_color.dart';

enum FlashbarType { SUCCESS, ERROR }

class Flashbar {
  final String _title;
  final String _content;
  final FlashController _controller;
  final FlashbarType _type;

  Flashbar({
    required String title,
    required String content,
    required FlashController controller,
    required FlashbarType type,
  })  : _title = title,
        _content = content,
        _controller = controller,
        _type = type;

  Flash flash() {
    return Flash(
      controller: _controller,
      barrierBlur: 0.0,
      behavior: FlashBehavior.floating,
      position: FlashPosition.top,
      backgroundColor: AppColor.black,
      margin: const EdgeInsets.all(32),
      borderRadius: BorderRadius.circular(2.0),
      forwardAnimationCurve: Curves.easeInQuint,
      reverseAnimationCurve: Curves.easeOutQuint,
      child: FlashBar(
        icon: Icon(
          _type == FlashbarType.SUCCESS
              ? Ionicons.checkmark_circle
              : Ionicons.remove_circle,
          color: _type == FlashbarType.SUCCESS ? AppColor.green : AppColor.red,
        ),
        title: Text(
          _title,
          style: Get.textTheme.headline5,
        ),
        content: Text(
          _content,
          style: Get.textTheme.bodyText2?.copyWith(color: AppColor.dark),
        ),
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
