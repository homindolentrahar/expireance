import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/domain/models/expire_category_model.dart';
import 'package:expireance/presentation/widgets/core/tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ExpireCategory extends StatelessWidget {
  final String valueId;
  final List<ExpireCategoryModel> models;
  final ValueChanged<ExpireCategoryModel> selectCategory;

  const ExpireCategory({
    Key? key,
    this.valueId = "",
    required this.models,
    required this.selectCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _selectedCategory = valueId.isEmpty
        ? "Category"
        : models.firstWhere((el) => el.id == valueId).name;

    return InkWell(
      onTap: () {
        Get.bottomSheet(
          Container(
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(2),
            ),
            child: SizedBox(
              height: 240,
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
