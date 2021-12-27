import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_route/auto_route.dart';

class ExpireItemPriority extends StatelessWidget {
  final int priorityCount;

  const ExpireItemPriority({
    Key? key,
    required this.priorityCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.push(const PriorityExpireRoute());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/warning.svg",
              width: 24,
              height: 24,
              color: AppColor.red,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    priorityCount > 1
                        ? "$priorityCount items will expire in a week"
                        : "$priorityCount item will expire in a week",
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Theme.of(context).canvasColor,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    priorityCount > 1
                        ? "Take care of your items before it goes waste"
                        : "Take care of your item before it goes waste",
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: AppColor.gray,
                          fontWeight: FontWeight.normal,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                context.router.push(const PriorityExpireRoute());
              },
              child: SvgPicture.asset(
                "assets/icons/caret-right.svg",
                width: 24,
                height: 24,
                color: AppColor.gray,
              ),
            )
          ],
        ),
      ),
    );
  }
}
