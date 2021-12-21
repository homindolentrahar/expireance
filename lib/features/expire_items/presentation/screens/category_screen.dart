import 'package:expireance/di/app_module.dart';
import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:expireance/features/expire_items/presentation/controllers/category_controller.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_body.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_category.dart';
import 'package:expireance/core/presentation/buttons.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  static const route = "/category";

  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryId = Get.arguments?.toString();

    return BlocProvider<FilteredItemCubit>(
      create: (ctx) => FilteredItemCubit(injector.get<IExpireRepository>())
        ..filterItem(categoryId: categoryId),
      child: Builder(builder: (builderCtx) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: const IconBackButton(),
              title: Text(
                "Expire Categories",
                style: Get.textTheme.headline6,
              ),
            ),
            body: BlocBuilder<FilteredItemCubit, FilteredItemState>(
              bloc: builderCtx.read<FilteredItemCubit>(),
              builder: (ctx, filteredState) => Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: BlocBuilder<CategoryCubit, List<CategoryModel>>(
                        bloc: builderCtx.read<CategoryCubit>(),
                        builder: (ctx, categories) => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: categories.map((cat) {
                            final selectedCategory =
                                filteredState.selectedCategoryId;

                            return ExpireCategoryBadge(
                              model: cat,
                              selected: selectedCategory == cat.id,
                              selectCategory: (category) {
                                if (category.id == selectedCategory) {
                                  builderCtx
                                      .read<FilteredItemCubit>()
                                      .filterItem();
                                } else {
                                  builderCtx
                                      .read<FilteredItemCubit>()
                                      .filterItem(categoryId: category.id);
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Builder(builder: (_) {
                        if (filteredState.loading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (filteredState.items.isEmpty) {
                          return const ExpireItemsNotFound();
                        } else if (filteredState.items.isNotEmpty) {
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: filteredState.items.length,
                            itemBuilder: (ctx, index) {
                              final model = filteredState.items[index];

                              return ExpireItemList(model: model);
                            },
                          );
                        } else if (filteredState.errorMessage.isNotEmpty) {
                          return Center(
                            child: Text(filteredState.errorMessage),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}