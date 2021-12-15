import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/domain/models/expire_item_model.dart';
import 'package:expireance/presentation/widgets/expire/expire_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExpireItemsNotFound extends StatelessWidget {
  const ExpireItemsNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/icons/expire-items.svg",
          width: 32,
          height: 32,
          color: AppColor.gray,
        ),
        const SizedBox(height: 16),
        const Text(
          "No items found",
          style: TextStyle(
            color: AppColor.gray,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class ExpireItemsGrid extends StatelessWidget {
  final List<ExpireItemModel> items;

  const ExpireItemsGrid({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1 / 1.5,
      ),
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        final model = items[index];

        return ExpireItemGrid(model: model);
      },
    );
  }
}
