import 'package:expireance/core/presentation/widgets/fields.dart';
import 'package:expireance/core/presentation/widgets/flashbar.dart';
import 'package:expireance/core/presentation/widgets/loading.dart';
import 'package:expireance/core/presentation/widgets/sheets.dart';
import 'package:expireance/di/app_module.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:expireance/features/expire_items/presentation/application/expire_actor.dart';
import 'package:expireance/features/expire_items/presentation/application/expire_watcher.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_body.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_forms.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SearchExpireScreen extends StatelessWidget {
  static const route = "/search";

  const SearchExpireScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchedExpireWatcher>(
      create: (ctx) => SearchedExpireWatcher(injector.get<IExpireRepository>()),
      child: SafeArea(
        child: Scaffold(
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
                },
              ),
            ],
            child: Builder(builder: (bodyCtx) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SearchField(
                      onChanged: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            bodyCtx
                                .read<SearchedExpireWatcher>()
                                .clearSearchedItem();
                          } else if (value.length >= 3) {
                            bodyCtx
                                .read<SearchedExpireWatcher>()
                                .searchItem(value);
                          } else {
                            bodyCtx
                                .read<SearchedExpireWatcher>()
                                .clearSearchedItem();
                          }
                        } else {
                          bodyCtx
                              .read<SearchedExpireWatcher>()
                              .clearSearchedItem();
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<SearchedExpireWatcher,
                      SearchedExpireWatcherState>(
                    builder: (ctx, state) => Expanded(
                      child: Builder(builder: (_) {
                        if (state.loading) {
                          return const LoadingIndicator();
                        } else if (state.error.isNotEmpty) {
                          return ExpireItemError(message: state.error);
                        } else if (state.items.isNotEmpty) {
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            itemCount: state.items.length,
                            itemBuilder: (ctx, index) {
                              final model = state.items[index];

                              return ExpireItemList(
                                model: model,
                                onPressed: () {
                                  showBarModalBottomSheet(
                                    context: context,
                                    bounce: true,
                                    expand: false,
                                    topControl: const SheetIndicator(),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                    ),
                                    builder: (ctx) => Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                      ),
                                      child: UpdateExpireForm(id: model.id),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).canvasColor,
                                  );
                                },
                              );
                            },
                          );
                        } else if (state.items.isEmpty) {
                          return const SearchedItemNotFound();
                        } else {
                          return const SearchedItemEmpty();
                        }
                      }),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
