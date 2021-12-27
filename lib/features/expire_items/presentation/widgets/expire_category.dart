import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/core/presentation/widgets/tiles.dart';
import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:expireance/features/expire_items/presentation/application/category_watcher.dart';
import 'package:expireance/core/presentation/widgets/buttons.dart';
import 'package:expireance/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_route/auto_route.dart';

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
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (ctx) => SizedBox(
            height: 280,
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
          ),
          backgroundColor: Theme.of(context).canvasColor,
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
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        color: selected ? Theme.of(context).primaryColor : AppColor.light,
        child: Text(
          model.name,
          style: Theme.of(context).textTheme.bodyText2?.copyWith(
                color: selected
                    ? Theme.of(context).canvasColor
                    : Theme.of(context).primaryColor,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
        ),
        onPressed: () => selectCategory(model),
      ),
    );
  }
}

class ExpireCategoryMenu extends StatelessWidget {
  const ExpireCategoryMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 128,
            child: BlocBuilder<CategoryWatcher, List<CategoryModel>>(
              bloc: context.read<CategoryWatcher>(),
              builder: (ctx, state) => GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 64,
                  crossAxisCount: 3,
                  mainAxisExtent: 64,
                ),
                itemCount: state.take(6).toList().length,
                itemBuilder: (ctx, index) {
                  return _ExpireCategoryMenuItem(
                    index: index,
                    category: state.take(6).toList()[index],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextualButton(
            text: "All Categories",
            fontSize: 12,
            onTap: () {
              context.router.push(CategoryRoute());
            },
          ),
        ],
      ),
    );
  }
}

class _ExpireCategoryMenuItem extends StatelessWidget {
  final int index;
  final CategoryModel category;

  const _ExpireCategoryMenuItem({
    Key? key,
    required this.index,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.push(CategoryRoute(categoryId: category.id));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: AppColor.getColor(index: index).withOpacity(0.15),
            ),
            child: Text(
              category.name.substring(0, 2),
              style: TextStyle(
                color: AppColor.getColor(index: index),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: const TextStyle(
              color: AppColor.gray,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
