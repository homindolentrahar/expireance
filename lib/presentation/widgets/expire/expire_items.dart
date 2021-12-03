import 'dart:io';
import 'dart:ui';

import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/domain/models/expire_item_model.dart';
import 'package:expireance/presentation/widgets/expire/expire_badges.dart';
import 'package:expireance/presentation/widgets/expire/expire_sheets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ExpireItemGrid extends StatelessWidget {
  final ExpireItemModel model;

  const ExpireItemGrid({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.card,
      child: GestureDetector(
        onTap: () {
          ExpireSheets.updateExpireItem(model.id);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withOpacity(0.04),
                offset: const Offset(2, 2),
                spreadRadius: 0,
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
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
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Get.theme.canvasColor,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        model.amount.toString(),
                        style: const TextStyle(
                          color: AppColor.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Get.theme.canvasColor,
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
                          style: Get.textTheme.headline5,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          model.category.name,
                          style: Get.textTheme.bodyText2
                              ?.copyWith(color: AppColor.gray),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ExpireTimeBadge(expiredDate: model.date),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
