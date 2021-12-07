import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/domain/models/expire_category_model.dart';
import 'package:expireance/presentation/widgets/core/tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ExpireCategory extends StatelessWidget {
  final ExpireCategoryModel value;
  final List<ExpireCategoryModel> models;
  final ValueChanged<ExpireCategoryModel> selectCategory;

  const ExpireCategory({
    Key? key,
    required this.value,
    required this.models,
    required this.selectCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _selectedCategory = value.id.isEmpty ? "Category" : value.name;

    return InkWell(
      onTap: () {
        Get.bottomSheet(
          SizedBox(
            height: 280,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: models.length,
              itemBuilder: (ctx, index) {
                final model = models[index];

                return TextTiles(
                  title: model.name,
                  onTap: () {
                    selectCategory(model);
                  },
                );
              },
            ),
          ),
          backgroundColor: Get.theme.canvasColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
      borderRadius: BorderRadius.circular(2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.gray, width: 1),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _selectedCategory,
              style: Get.textTheme.bodyText2?.copyWith(
                color: _selectedCategory == "Category"
                    ? AppColor.gray
                    : AppColor.black,
                fontWeight: _selectedCategory == "Category"
                    ? FontWeight.normal
                    : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            SvgPicture.asset(
              "assets/icons/caret-down.svg",
              width: 20,
              height: 20,
              color: _selectedCategory == "Category"
                  ? AppColor.gray
                  : AppColor.black,
            ),
          ],
        ),
      ),
    );
  }
}

class ExpireCategoryBadge extends StatelessWidget {
  final ExpireCategoryModel model;
  final bool selected;
  final ValueChanged<ExpireCategoryModel> selectCategory;

  const ExpireCategoryBadge({
    Key? key,
    required this.model,
    this.selected = false,
    required this.selectCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      minWidth: 0,
      height: 0,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      color: selected ? Get.theme.primaryColor : AppColor.light,
      child: Text(
        model.name,
        style: Get.textTheme.bodyText2?.copyWith(
          color: selected ? Get.theme.canvasColor : Get.theme.primaryColor,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onPressed: () => selectCategory(model),
    ).marginSymmetric(horizontal: 8);
  }
}
