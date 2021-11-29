import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/presentation/controller/expire_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExpireFragment extends StatelessWidget {
  const ExpireFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.expireItems.length,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.expireItems[index].name,
                            style: Get.textTheme.headline6,
                          ),
                          Text(
                            controller.expireItems[index].desc,
                            style: Get.textTheme.bodyText2?.copyWith(
                              color: AppColor.dark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat.yMMMd().format(
                            controller.expireItems[index].date,
                          ),
                          style: const TextStyle(color: AppColor.gray),
                        ),
                        Text(
                          controller.expireItems[index].amount.toString(),
                          style: Get.textTheme.headline6?.copyWith(
                            color: AppColor.dark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
