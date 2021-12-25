import 'package:expireance/core/presentation/fields.dart';
import 'package:expireance/di/app_module.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:expireance/features/expire_items/presentation/application/expire_watcher.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_body.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchedExpireWatcher>(
      create: (ctx) => SearchedExpireWatcher(injector.get<IExpireRepository>()),
      child: SafeArea(
        child: Scaffold(
          body: Builder(builder: (bodyCtx) {
            return Column(
              children: [
                SearchField(
                  onChanged: (value) {
                    if (value != null) {
                      if (value.length >= 3) {
                        bodyCtx.read<SearchedExpireWatcher>().searchItem(value);
                      } else {
                        bodyCtx
                            .read<SearchedExpireWatcher>()
                            .clearSearchedItem();
                      }
                    } else if (value!.isEmpty) {
                      bodyCtx.read<SearchedExpireWatcher>().clearSearchedItem();
                    } else {
                      bodyCtx.read<SearchedExpireWatcher>().clearSearchedItem();
                    }
                  },
                ).marginAll(16),
                const SizedBox(height: 16),
                BlocBuilder<SearchedExpireWatcher, SearchedExpireWatcherState>(
                  builder: (ctx, state) => Expanded(
                    child: Builder(builder: (_) {
                      if (state.loading) {
                        return ExpireItemLoading(
                          enabled: state.loading,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: 0,
                            itemBuilder: (ctx, index) =>
                                const SizedBox.shrink(),
                          ),
                        );
                      } else if (state.error.isNotEmpty) {
                        return ExpireItemError(message: state.error);
                      } else if (state.items.isNotEmpty) {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount: state.items.length,
                          itemBuilder: (ctx, index) {
                            final model = state.items[index];

                            return ExpireItemList(model: model);
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
    );
  }
}
