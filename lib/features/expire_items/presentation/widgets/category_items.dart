import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/core/presentation/widgets/buttons.dart';
import 'package:expireance/core/presentation/widgets/dialogs.dart';
import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:expireance/features/expire_items/presentation/application/category_actor.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryItemList extends StatelessWidget {
  final CategoryModel model;
  final VoidCallback onTap;

  const CategoryItemList({Key? key, required this.model, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final immutable = model.slug == "uncategorized";

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: immutable ? null : onTap,
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
              immutable
                  ? const SizedBox.shrink()
                  : DeleteButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => DangerConfirmationDialog(
                            title: "Delete category ${model.name}",
                            message:
                                "After this action, you'll not be able to use ${model.name} as your item's category",
                            onPositive: () {
                              //  Delete category
                              context
                                  .read<CategoryActor>()
                                  .deleteCategory(model.id);

                              context.router.pop();
                            },
                            onNegative: () {
                              context.router.pop();
                            },
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
