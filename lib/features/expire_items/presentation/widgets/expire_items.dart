import 'dart:io';

import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/features/expire_items/domain/models/expire_item_model.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_badge.dart';
import 'package:expireance/utils/date_time_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExpireItemGrid extends StatelessWidget {
  final ExpireItemModel model;
  final VoidCallback onPressed;

  const ExpireItemGrid({
    Key? key,
    required this.model,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isExpired = DateTimeUtils.isExpired(model.date);

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      splashColor: Theme.of(context).primaryColor.withOpacity(0.025),
      highlightColor: Theme.of(context).primaryColor.withOpacity(0.05),
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: model.image.isNotEmpty
                    ? Image.file(
                        File(model.image),
                        width: double.infinity,
                        height: 176,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: double.infinity,
                        height: 176,
                        alignment: Alignment.center,
                        color: AppColor.light,
                        child: SvgPicture.asset(
                          "assets/icons/image.svg",
                          width: 32,
                          height: 32,
                          color: AppColor.gray,
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isExpired
                        ? AppColor.dark
                        : Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    model.amount.toString(),
                    style: TextStyle(
                      color: isExpired ? AppColor.light : AppColor.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: isExpired ? AppColor.gray : AppColor.black,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      model.category.name,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            color: AppColor.gray,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ExpireBadge(expiredDate: model.date),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExpireItemList extends StatelessWidget {
  final ExpireItemModel model;
  final VoidCallback onPressed;

  const ExpireItemList({
    Key? key,
    required this.model,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isExpired = DateTime.now().isAfter(model.date);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          color: Theme.of(context).canvasColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.topRight,
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: model.image.isNotEmpty
                        ? Image.file(
                            File(model.image),
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 52,
                            height: 52,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColor.light,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/image.svg",
                              width: 20,
                              height: 20,
                              color: AppColor.gray,
                            ),
                          ),
                  ),
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isExpired
                            ? AppColor.dark
                            : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(360),
                      ),
                      child: Text(
                        model.amount.toString(),
                        style: TextStyle(
                          color: isExpired
                              ? AppColor.light
                              : Theme.of(context).canvasColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: isExpired ? AppColor.gray : AppColor.black,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      model.desc,
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
              ExpireBadge(
                expiredDate: model.date,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
