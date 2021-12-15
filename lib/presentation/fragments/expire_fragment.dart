import 'package:expireance/features/expire_items/presentation/widgets/expire_body.dart';
import 'package:expireance/presentation/controller/expire/expire_controller.dart';
import 'package:expireance/presentation/widgets/core/refresh_header.dart';
import 'package:expireance/presentation/widgets/expire/expire_category.dart';
import 'package:expireance/presentation/widgets/expire/expire_item_priority.dart';
import 'package:expireance/presentation/widgets/expire/expire_sort.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ExpireFragment extends StatelessWidget {
  const ExpireFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final refreshController = RefreshController(initialRefresh: false);

    return NestedScrollView(
      physics: const BouncingScrollPhysics(),
      headerSliverBuilder: (ctx, _) => [
        SliverAppBar(
          title: const Text("Expire Items"),
          centerTitle: true,
          titleTextStyle: Get.theme.appBarTheme.titleTextStyle,
          actions: [
            IconButton(
              onPressed: () {
                Get.toNamed("/search");
              },
              icon: SvgPicture.asset(
                "assets/icons/search.svg",
                width: 24,
                height: 24,
                color: Get.theme.primaryColor,
              ),
            ),
          ],
        ),
      ],
      body: GetX<ExpireController>(
        init: Get.find<ExpireController>()
          ..listenExpireItems()
          ..listenPriorityExpireItems()
          ..fetchCategories(),
        builder: (controller) {
          return SmartRefresher(
            controller: refreshController,
            physics: const BouncingScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            header: const RefreshHeader(),
            onRefresh: () {
              controller.listenExpireItems();

              refreshController.refreshCompleted();
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  controller.priorityExpireItems.isEmpty
                      ? const SizedBox.shrink()
                      : ExpireItemPriority(
                          models: controller.priorityExpireItems,
                        ),
                  const SizedBox(height: 16),
                  const ExpireCategoryMenu(),
                  const SizedBox(height: 16),
                  ExpireSort(
                    sortingRule: controller.sortingRule,
                    categoryFilteringRule: controller.categoryFilteringRule,
                    categories: controller.expireCategories,
                    setSortingRule: (selected) {
                      controller.setSortingRule(selected);

                      controller.listenExpireItems();

                      Get.back();
                    },
                    setCategoryFilteringRule: (selected) {
                      final String rule;

                      if (controller.categoryFilteringRule == selected.id) {
                        rule = "";
                      } else {
                        rule = selected.id;
                      }

                      controller.setCategoryFilteringRule(rule);

                      controller.listenExpireItems();
                    },
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: controller.expireItems.isNotEmpty
                        ? ExpireItemsGrid(items: controller.expireItems)
                        : const ExpireItemsNotFound(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
