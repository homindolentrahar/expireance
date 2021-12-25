import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expireance/features/expire_items/domain/models/expire_item_model.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';

part 'expire_watcher.freezed.dart';

enum ExpireItemSort { all, name, expired }

class PriorityExpireWatcher extends Cubit<ExpireWatcherState> {
  final IExpireRepository _expireRepository;
  StreamSubscription? priorityExpireItemSubscription;

  PriorityExpireWatcher(this._expireRepository)
      : super(ExpireWatcherState.initial());

  Future<void> listenPriorityExpireItems() async {
    emit(ExpireWatcherState.loading());

    await priorityExpireItemSubscription?.cancel();
    priorityExpireItemSubscription = _expireRepository
        .listenExpireItems()
        .listen(
          (either) => either.fold(
            (error) {
              emit(ExpireWatcherState.error(error: error.message));
            },
            (success) {
              emit(
                ExpireWatcherState.success(
                  items: success
                      .where(
                        (item) =>
                            item.date.difference(DateTime.now()).inDays <= 7 &&
                            item.date.difference(DateTime.now()).inMinutes > 1,
                      )
                      .toList(),
                  sortingRule: ExpireItemSort.all,
                  filteringRule: "",
                ),
              );
            },
          ),
        );
  }

  @override
  Future<void> close() async {
    await priorityExpireItemSubscription?.cancel();

    return super.close();
  }
}

class ExpireWatcher extends Cubit<ExpireWatcherState> {
  final IExpireRepository _expireRepository;
  StreamSubscription? expireItemSubscription;

  ExpireWatcher(this._expireRepository) : super(ExpireWatcherState.initial());

  Future<void> listenExpireItems({
    ExpireItemSort sortingRule = ExpireItemSort.all,
    String filteringRule = "",
  }) async {
    emit(ExpireWatcherState.loading());

    await expireItemSubscription?.cancel();
    expireItemSubscription = _expireRepository.listenExpireItems().listen(
          (either) => either.fold(
            (error) {
              emit(ExpireWatcherState.error(error: error.message));
            },
            (success) {
              emit(
                ExpireWatcherState.success(
                  sortingRule: sortingRule,
                  filteringRule: filteringRule,
                  items: success
                      .where(
                        (item) => filteringRule.isNotEmpty
                            ? item.category.id == filteringRule
                            : true,
                      )
                      .where(
                        (item) => sortingRule == ExpireItemSort.expired
                            ? DateTime.now().isAfter(item.date)
                            : true,
                      )
                      .sorted(
                    (a, b) {
                      if (sortingRule == ExpireItemSort.name) {
                        return a.name.compareTo(b.name);
                      } else {
                        return a.date.compareTo(b.date);
                      }
                    },
                  ).toList(),
                ),
              );
            },
          ),
        );
  }

  @override
  Future<void> close() async {
    await expireItemSubscription?.cancel();

    return super.close();
  }
}

class SingleExpireWatcher extends Cubit<ExpireItemModel?> {
  final IExpireRepository _expireRepository;
  final String id;

  SingleExpireWatcher(this._expireRepository, {required this.id})
      : super(null) {
    final result = _expireRepository.fetchSingleExpireItem(id: id);

    emit(
      result.fold(
        (error) {
          return null;
        },
        (data) {
          return data;
        },
      ),
    );
  }
}

class FilteredExpireWatcher extends Cubit<FilteredExpireWatcherState> {
  final IExpireRepository _expireRepository;
  StreamSubscription? expireItemsSubscription;

  FilteredExpireWatcher(this._expireRepository)
      : super(const FilteredExpireWatcherState());

  Future<void> filterItem({String? categoryId}) async {
    emit(state.copyWith(loading: true, selectedCategoryId: categoryId));

    expireItemsSubscription?.cancel();
    expireItemsSubscription =
        _expireRepository.listenExpireItems(categoryId: categoryId).listen(
      (either) {
        emit(
          either.fold(
            (error) => state.copyWith(
              error: error.message,
              items: [],
              loading: false,
            ),
            (success) => state.copyWith(
              items: success.sorted((a, b) => a.date.compareTo(b.date)),
              loading: false,
            ),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    await expireItemsSubscription?.cancel();

    return super.close();
  }
}

class SearchedExpireWatcher extends Cubit<SearchedExpireWatcherState> {
  final IExpireRepository _expireRepository;
  StreamSubscription? expireItemsSubscription;

  SearchedExpireWatcher(this._expireRepository)
      : super(const SearchedExpireWatcherState());

  Future<void> searchItem(String query) async {
    emit(state.copyWith(loading: true, query: query));

    await expireItemsSubscription?.cancel();
    expireItemsSubscription = _expireRepository
        .searchExpireItems(query: query)
        .debounceTime(const Duration(milliseconds: 300))
        .listen((either) {
      emit(
        either.fold(
          (error) => state.copyWith(
            error: error.message,
            items: [],
            loading: false,
          ),
          (success) => state.copyWith(
            items: success,
            loading: false,
          ),
        ),
      );
    });
  }

  void clearSearchedItem() {
    emit(
      state.copyWith(
        error: "",
        items: [],
        loading: false,
      ),
    );
  }

  @override
  Future<void> close() async {
    await expireItemsSubscription?.cancel();

    return super.close();
  }
}

@freezed
class FilteredExpireWatcherState with _$FilteredExpireWatcherState {
  const factory FilteredExpireWatcherState({
    @Default(null) String? selectedCategoryId,
    @Default(false) bool loading,
    @Default([]) List<ExpireItemModel> items,
    @Default("") String error,
  }) = _FilteredExpireWatcherState;
}

@freezed
class SearchedExpireWatcherState with _$SearchedExpireWatcherState {
  const factory SearchedExpireWatcherState({
    @Default("") String query,
    @Default(false) bool loading,
    @Default([]) List<ExpireItemModel> items,
    @Default("") String error,
  }) = _SearchedExpireWatcherState;
}

@freezed
class ExpireWatcherState with _$ExpireWatcherState {
  const factory ExpireWatcherState._({
    @Default(false) loading,
    @Default([]) List<ExpireItemModel> items,
    @Default("") String error,
    @Default(ExpireItemSort.all) ExpireItemSort sortingRule,
    @Default("") String filteringRule,
  }) = _ExpireWatcherState;

  factory ExpireWatcherState.initial() => const ExpireWatcherState._();

  factory ExpireWatcherState.loading() => const ExpireWatcherState._(
        loading: true,
        items: [],
        error: "",
        sortingRule: ExpireItemSort.all,
        filteringRule: "",
      );

  factory ExpireWatcherState.success({
    required List<ExpireItemModel> items,
    required ExpireItemSort sortingRule,
    required String filteringRule,
  }) =>
      ExpireWatcherState._(
        loading: false,
        items: items,
        error: "",
        sortingRule: sortingRule,
        filteringRule: filteringRule,
      );

  factory ExpireWatcherState.error({required String error}) =>
      ExpireWatcherState._(
        loading: false,
        items: [],
        error: error,
        sortingRule: ExpireItemSort.all,
        filteringRule: "",
      );
}
