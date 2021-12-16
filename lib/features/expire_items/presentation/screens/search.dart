import 'dart:developer';

import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/core/presentation/fields.dart';
import 'package:expireance/features/expire_items/presentation/controllers/expire_search_controller.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetX<ExpireSearchController>(
        init: Get.find<ExpireSearchController>(),
        builder: (controller) => Scaffold(
          body: Column(
            children: [
              SearchField(
                onChanged: (value) {
                  log("Search query: $value");
                  if (value != null) {
                    if (value.length >= 3) {
                      controller.searchExpireItems(value);
                    } else {
                      controller.emptySearchedExpireItems();
                    }
                  } else if (value!.isEmpty) {
                    controller.emptySearchedExpireItems();
                  } else {
                    controller.emptySearchedExpireItems();
                  }
                },
              ).marginAll(16),
              const SizedBox(height: 16),
              Expanded(
                child: controller.searchedExpireItems.isNotEmpty
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.searchedExpireItems.length,
                        itemBuilder: (ctx, index) {
                          final model = controller.searchedExpireItems[index];

                          return ExpireItemList(model: model).marginAll(16);
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/search.svg",
                            width: 24,
                            height: 24,
                            color: AppColor.gray,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Search your expire items",
                            style: TextStyle(
                              color: AppColor.gray,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
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
