import 'dart:ui';

import 'package:expireance/common/theme/app_color.dart';

abstract class DateTimeUtils {
  static bool isExpired(DateTime expiredDate) {
    return DateTime.now().isAfter(expiredDate);
  }

  static Map<Color, String> calculateColorAndDisplayExpireBadge({
    required DateTime expiredDate,
  }) {
    const int nDay = 24;
    const int nWeek = 168;
    const int nMonth = 720;
    final Color color;
    final String display;

    final hours = expiredDate.difference(DateTime.now()).inHours;
    final minutes = expiredDate.difference(DateTime.now()).inMinutes;

    //Conditional rendering
    // --- Color
    if (hours > 0 && hours <= nWeek) {
      color = AppColor.red;
    } else if (hours > 168 && hours <= 336) {
      color = AppColor.orange;
    } else if (hours > 336 && hours <= 672) {
      color = AppColor.yellow;
    } else if (hours > 672 && hours <= 2160) {
      color = AppColor.green;
    } else if (hours > 2160) {
      color = AppColor.teal;
    } else {
      color = AppColor.red;
    }
    // --- Text
    if (minutes > 0 && minutes <= 60) {
      display = "${minutes}m";
    } else if (hours > 1 && hours <= nDay) {
      display = "${hours}h";
    } else if (hours > nDay && hours <= (nWeek * 2)) {
      final days = (hours / nDay).floor();
      display = "${days}d";
    } else if (hours > (nWeek * 2) && hours <= nMonth) {
      final weeks = (hours / nWeek).floor();
      display = "${weeks}w";
    } else if (hours > nMonth) {
      final months = (hours / nMonth).floor();
      display = "${months}M";
    } else {
      display = "${hours}h";
    }

    return {color: display};
  }
}
