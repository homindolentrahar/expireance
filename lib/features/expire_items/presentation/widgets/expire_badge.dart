import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/utils/date_time_utils.dart';
import 'package:flutter/material.dart';

class ExpireBadge extends StatelessWidget {
  final DateTime expiredDate;

  const ExpireBadge({
    Key? key,
    required this.expiredDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorAndDisplay = DateTimeUtils.calculateColorAndDisplayExpireBadge(
      expiredDate: expiredDate,
    );

    return DateTimeUtils.isExpired(expiredDate)
        ? const _Expired()
        : _ExpireTime(
            text: colorAndDisplay.values.toList()[0],
            color: colorAndDisplay.keys.toList()[0],
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
        borderRadius: BorderRadius.circular(8),
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
