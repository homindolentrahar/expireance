import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/core/presentation/widgets/sheets.dart';
import 'package:expireance/core/presentation/widgets/tiles.dart';
import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:expireance/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_route/auto_route.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ExpireCategorySelector extends StatelessWidget {
  final CategoryModel? value;
  final List<CategoryModel> models;
  final ValueChanged<CategoryModel> selectCategory;

  const ExpireCategorySelector({
    Key? key,
    required this.value,
    required this.models,
    required this.selectCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _selectedCategory = value?.name ?? "Category";

    return InkWell(
      splashColor: Theme.of(context).primaryColor.withOpacity(0.025),
      highlightColor: Theme.of(context).primaryColor.withOpacity(0.05),
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        showBarModalBottomSheet(
          context: context,
          bounce: true,
          expand: false,
          enableDrag: false,
          topControl: const SheetIndicator(),
          backgroundColor: Theme.of(context).canvasColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16),
            ),
          ),
          builder: (ctx) => models.length > 3
              ? SizedBox(
                  height: 256,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: models.length,
                    itemBuilder: (ctx, index) {
                      final model = models[index];

                      return TextTiles(
                        title: model.name,
                        selected: model.id == value?.id,
                        onTap: () {
                          selectCategory(model);
                        },
                      );
                    },
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: models
                      .map(
                        (model) => TextTiles(
                          title: model.name,
                          selected: model.id == value?.id,
                          onTap: () {
                            selectCategory(model);
                          },
                        ),
                      )
                      .toList(),
                ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _selectedCategory == "Category"
              ? AppColor.light.withOpacity(0.5)
              : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _selectedCategory,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    color: _selectedCategory == "Category"
                        ? AppColor.gray
                        : Theme.of(context).canvasColor,
                    fontWeight: _selectedCategory == "Category"
                        ? FontWeight.w500
                        : FontWeight.w600,
                  ),
            ),
            const SizedBox(width: 12),
            SvgPicture.asset(
              "assets/icons/caret-down.svg",
              width: 20,
              height: 20,
              color: _selectedCategory == "Category"
                  ? AppColor.gray
                  : Theme.of(context).canvasColor,
            ),
          ],
        ),
      ),
    );
  }
}

class ExpireCategoryBadge extends StatelessWidget {
  final CategoryModel model;
  final bool selected;
  final ValueChanged<CategoryModel> selectCategory;

  const ExpireCategoryBadge({
    Key? key,
    required this.model,
    this.selected = false,
    required this.selectCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: MaterialButton(
        elevation: 0,
        highlightElevation: 0,
        minWidth: 0,
        height: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: selected ? Theme.of(context).primaryColor : AppColor.light,
        child: Text(
          model.name,
          style: Theme.of(context).textTheme.bodyText2?.copyWith(
                color: selected
                    ? Theme.of(context).canvasColor
                    : Theme.of(context).primaryColor,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
        ),
        onPressed: () => selectCategory(model),
      ),
    );
  }
}

class ExpireCategoryBanner extends StatelessWidget {
  const ExpireCategoryBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.push(FilteredExpireRoute());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: 6,
              child: SvgPicture.asset(
                "assets/icons/category.svg",
                width: 24,
                height: 24,
                color: Theme.of(context).canvasColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Explore your items",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Theme.of(context).canvasColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Find your items based on their category",
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: AppColor.gray,
                          fontWeight: FontWeight.normal,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                context.router.push(FilteredExpireRoute());
              },
              child: SvgPicture.asset(
                "assets/icons/caret-right.svg",
                width: 24,
                height: 24,
                color: Theme.of(context).canvasColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
