import 'package:expireance/core/presentation/widgets/drawers.dart';
import 'package:expireance/core/presentation/widgets/flashbar.dart';
import 'package:expireance/core/presentation/widgets/loading.dart';
import 'package:expireance/core/presentation/widgets/refresh_header.dart';
import 'package:expireance/core/presentation/widgets/sheets.dart';
import 'package:expireance/di/app_module.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:expireance/features/expire_items/presentation/application/expire_actor.dart';
import 'package:expireance/features/expire_items/presentation/application/expire_watcher.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_body.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_category.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_forms.dart';
import 'package:expireance/core/presentation/widgets/buttons.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_item_priority.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_sort.dart';
import 'package:expireance/routes/app_routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ExpireScreen extends StatelessWidget {
  static const route = "/expire";

  const ExpireScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final refreshController = RefreshController(initialRefresh: false);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: ExpireWatcher(injector.get<IExpireRepository>()),
        ),
        BlocProvider.value(
          value: PriorityExpireWatcher(injector.get<IExpireRepository>()),
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          drawer: const RootDrawer(),
          appBar: AppBar(
            leading: const IconHamburgerButton(),
            title: const Text("Expire Items"),
            centerTitle: true,
            titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
            actions: [
              IconButton(
                onPressed: () {
                  context.router.push(const SearchExpireRoute());
                },
                icon: SvgPicture.asset(
                  "assets/icons/search.svg",
                  width: 20,
                  height: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
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
                },
              ),
            ],
            child: Builder(
              builder: (bodyCtx) => SmartRefresher(
                controller: refreshController,
                physics: const BouncingScrollPhysics(),
                dragStartBehavior: DragStartBehavior.down,
                header: const RefreshHeader(),
                onRefresh: () {
                  final filteringRule =
                      bodyCtx.read<ExpireWatcher>().state.filteringRule;
                  final sortingRule =
                      bodyCtx.read<ExpireWatcher>().state.sortingRule;

                  bodyCtx.read<ExpireWatcher>().listenExpireItems(
                        filteringRule: filteringRule,
                        sortingRule: sortingRule,
                      );

                  refreshController.refreshCompleted();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      BlocBuilder<PriorityExpireWatcher, ExpireWatcherState>(
                        bloc: bodyCtx.read<PriorityExpireWatcher>()
                          ..listenPriorityExpireItems(),
                        builder: (ctx, state) => state.items.isEmpty
                            ? const SizedBox.shrink()
                            : Column(
                                children: [
                                  ExpireItemPriority(
                                    priorityCount: state.items.length,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                      ),
                      const ExpireCategoryBanner(),
                      const SizedBox(height: 16),
                      BlocBuilder<ExpireWatcher, ExpireWatcherState>(
                        bloc: bodyCtx.read<ExpireWatcher>()
                          ..listenExpireItems(
                            filteringRule: bodyCtx
                                .read<ExpireWatcher>()
                                .state
                                .filteringRule,
                            sortingRule:
                                bodyCtx.read<ExpireWatcher>().state.sortingRule,
                          ),
                        builder: (ctx, state) => Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ExpireSort(
                                sortingRule: state.sortingRule,
                                setSortingRule: (selected) {
                                  bodyCtx
                                      .read<ExpireWatcher>()
                                      .listenExpireItems(sortingRule: selected);

                                  context.router.pop();
                                },
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Builder(builder: (_) {
                                  if (state.loading) {
                                    return const LoadingIndicator();
                                  } else if (state.error.isNotEmpty) {
                                    return ExpireItemError(
                                        message: state.error);
                                  } else if (state.items.isNotEmpty) {
                                    return ExpireItemGridSuccess(
                                      items: state.items,
                                      onPressedItem: (index) {
                                        showBarModalBottomSheet(
                                          context: context,
                                          bounce: true,
                                          topControl: const SheetIndicator(),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(16),
                                              topLeft: Radius.circular(16),
                                            ),
                                          ),
                                          builder: (ctx) => UpdateExpireForm(
                                            id: state.items[index].id,
                                          ),
                                          backgroundColor:
                                              Theme.of(context).canvasColor,
                                        );
                                      },
                                    );
                                  } else if (state.items.isEmpty) {
                                    return const ExpireItemEmpty();
                                  } else {
                                    return const ExpireItemEmpty();
                                  }
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: FAB(
            onPressed: () {
              showBarModalBottomSheet(
                context: context,
                bounce: true,
                topControl: const SheetIndicator(),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                builder: (ctx) => const AddExpireForm(),
                backgroundColor: Theme.of(context).canvasColor,
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }
}
