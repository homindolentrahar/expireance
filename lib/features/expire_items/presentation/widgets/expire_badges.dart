import 'package:expireance/common/theme/app_color.dart';
import 'package:flutter/material.dart';

class ExpireTimeBadge extends StatelessWidget {
  final DateTime expiredDate;

  const ExpireTimeBadge({
    Key? key,
    required this.expiredDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    return DateTime.now().isAfter(expiredDate)
        ? const _Expired()
        : _ExpireTime(
            text: display,
            color: color,
          );
  }
}

class _ExpireTime extends StatelessWidget {
  final String text;
  final Color color;

  const _ExpireTime({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _Expired extends StatelessWidget {
  const _Expired({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.red,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        "Expired".toUpperCase(),
        style: const TextStyle(
          color: AppColor.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
