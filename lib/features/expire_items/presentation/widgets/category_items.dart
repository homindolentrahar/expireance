import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/core/presentation/widgets/dialogs.dart';
import 'package:expireance/core/presentation/widgets/sheets.dart';
import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:expireance/features/expire_items/presentation/widgets/category_forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:auto_route/auto_route.dart';

class CategoryItemList extends StatelessWidget {
  final CategoryModel model;

  const CategoryItemList({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showBarModalBottomSheet(
            context: context,
            builder: (ctx) => Container(
              color: AppColor.white,
              padding: const EdgeInsets.all(24),
              child: const AddCategoryForm(),
            ),
            topControl: const SheetIndicator(),
            backgroundColor: AppColor.white,
          );
        },
        splashColor: AppColor.light,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      model.slug,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: AppColor.gray),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => DangerConfirmationDialog(
                        title: "Delete category ${model.name}",
                        message:
                            "After this action, you'll not be able to use ${model.name} as your item's category",
                        onPositive: () {
                          //  Delete category
                        },
                        onNegative: () {
                          context.router.pop();
                        },
                      ),
                    );
                  },
                  splashColor: AppColor.red.withOpacity(0.25),
                  highlightColor: AppColor.red.withOpacity(0.35),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColor.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/delete.svg",
                      width: 20,
                      height: 20,
                      color: AppColor.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
