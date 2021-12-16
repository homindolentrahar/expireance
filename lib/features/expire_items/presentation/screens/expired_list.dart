import 'package:expireance/features/expire_items/presentation/controllers/expire_controller.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ExpiredList extends StatelessWidget {
  const ExpiredList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.canvasColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset(
              "assets/icons/back.svg",
              width: 24,
              height: 24,
              color: Get.theme.primaryColor,
            ),
          ),
          title: Text(
            "Expire items in a week",
            style: Get.textTheme.headline6,
          ),
        ),
        body: GetX<ExpireController>(
          init: Get.find<ExpireController>()..listenPriorityExpireItems(),
          builder: (controller) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.priorityExpireItems.length,
                    itemBuilder: (ctx, index) {
                      final model = controller.priorityExpireItems[index];

                      return ExpireItemList(model: model).marginAll(16);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
