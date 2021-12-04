import 'package:expireance/presentation/controller/expire/expire_controller.dart';
import 'package:expireance/presentation/widgets/core/refresh_header.dart';
import 'package:expireance/presentation/widgets/expire/expire_item_carousel.dart';
import 'package:expireance/presentation/widgets/expire/expire_items.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
        ),
      ],
      body: GetX<ExpireController>(
        init: Get.find<ExpireController>()..fetchExpireItems(),
        builder: (controller) {
          return SmartRefresher(
            controller: refreshController,
            physics: const BouncingScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            header: const RefreshHeader(),
            onRefresh: () {
              controller.fetchExpireItems();

              refreshController.refreshCompleted();
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: ExpireItemCarousel(
                    models: controller.expirePriorities,
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1 / 1.5,
                    ),
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.expireItems.length,
                    itemBuilder: (ctx, index) {
                      final model = controller.expireItems[index];

                      return ExpireItemGrid(model: model);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
