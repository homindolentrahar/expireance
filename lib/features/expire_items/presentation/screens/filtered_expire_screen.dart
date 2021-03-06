import 'package:expireance/core/presentation/widgets/flashbar.dart';
import 'package:expireance/di/app_module.dart';
import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:expireance/features/expire_items/presentation/application/category_watcher.dart';
import 'package:expireance/features/expire_items/presentation/application/expire_actor.dart';
import 'package:expireance/features/expire_items/presentation/application/expire_watcher.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_body.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_category.dart';
import 'package:expireance/core/presentation/widgets/buttons.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_forms.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_items.dart';
import 'package:expireance/utils/sheet_dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilteredExpireScreen extends StatelessWidget {
  static const route = "/filtered";

  final String? categoryId;

  const FilteredExpireScreen({
    Key? key,
    this.categoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FilteredExpireWatcher>(
      create: (ctx) => FilteredExpireWatcher(injector.get<IExpireRepository>()),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: const IconBackButton(),
            title: Text(
              "Expire Categories",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<ExpireActor, ExpireActorState>(
                  listener: (ctx, state) {
                state.maybeWhen(
                  success: (message) => Flashbar(
                    context: context,
                    title: "Yeay!",
                    content: message,
                    type: FlashbarType.SUCCESS,
                  ).flash(),
                  error: (message) => Flashbar(
                    context: context,
                    title: "Something happened!",
                    content: message,
                    type: FlashbarType.ERROR,
                  ).flash(),
                  orElse: () {},
                );
              }),
            ],
            child: Builder(builder: (builderCtx) {
              return BlocBuilder<FilteredExpireWatcher,
                  FilteredExpireWatcherState>(
                bloc: builderCtx.read<FilteredExpireWatcher>()
                  ..filterItem(categoryId: categoryId),
                builder: (ctx, filteredState) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child:
                            BlocBuilder<CategoryWatcher, List<CategoryModel>>(
                          bloc: builderCtx.read<CategoryWatcher>()
                            ..listenCategories(),
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
                                        .read<FilteredExpireWatcher>()
                                        .filterItem();
                                  } else {
                                    builderCtx
                                        .read<FilteredExpireWatcher>()
                                        .filterItem(categoryId: category.id);
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Builder(builder: (_) {
                          if (filteredState.loading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (filteredState.items.isEmpty) {
                            return const ExpireItemEmpty();
                          } else if (filteredState.items.isNotEmpty) {
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: filteredState.items.length,
                              itemBuilder: (ctx, index) {
                                final model = filteredState.items[index];

                                return ExpireItemList(
                                  model: model,
                                  onPressed: () {
                                    SheetDialogUtils.showAppBarSheet(
                                      context: context,
                                      child: UpdateExpireForm(
                                        id: model.id,
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          } else if (filteredState.error.isNotEmpty) {
                            return Center(
                              child: Text(filteredState.error),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
