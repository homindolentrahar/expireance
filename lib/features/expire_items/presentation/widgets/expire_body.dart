import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/features/expire_items/domain/models/expire_item_model.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExpireItemEmpty extends StatelessWidget {
  const ExpireItemEmpty({Key? key}) : super(key: key);

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
          "No expire items",
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

class ExpireItemGridSuccess extends StatelessWidget {
  final List<ExpireItemModel> items;
  final ValueChanged<int> onPressedItem;

  const ExpireItemGridSuccess({
    Key? key,
    required this.items,
    required this.onPressedItem,
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

        return ExpireItemGrid(
          model: model,
          onPressed: () => onPressedItem(index),
        );
      },
    );
  }
}

class SearchedItemEmpty extends StatelessWidget {
  const SearchedItemEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/icons/search.svg",
          width: 32,
          height: 32,
          color: AppColor.gray,
        ),
        const SizedBox(height: 16),
        const Text(
          "Search expire item",
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

class SearchedItemNotFound extends StatelessWidget {
  const SearchedItemNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/icons/search.svg",
          width: 32,
          height: 32,
          color: AppColor.gray,
        ),
        const SizedBox(height: 16),
        const Text(
          "Searched item not found",
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

class ExpireItemError extends StatelessWidget {
  final String message;

  const ExpireItemError({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/icons/cloud-error.svg",
          width: 32,
          height: 32,
          color: AppColor.gray,
        ),
        const SizedBox(height: 16),
        const Text(
          "No expire items",
          style: TextStyle(
            color: AppColor.gray,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          message,
          style: const TextStyle(
            color: AppColor.gray,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
