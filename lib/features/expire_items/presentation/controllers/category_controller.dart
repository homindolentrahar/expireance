import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:expireance/features/expire_items/domain/models/expire_item_model.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_category_repository.dart';

part 'category_controller.freezed.dart';

class CategoryCubit extends Cubit<List<CategoryModel>> {
  final ICategoryRepository _categoryRepository;

  CategoryCubit(this._categoryRepository) : super([]) {
    final result = _categoryRepository.fetchAllCategory();

    emit(result.fold(
      (error) {
        return [];
      },
      (success) {
        return success;
      },
    ));
  }
}

class FilteredItemCubit extends Cubit<FilteredItemState> {
  final IExpireRepository _expireRepository;
  StreamSubscription? expireItemsSubscription;

  FilteredItemCubit(this._expireRepository) : super(const FilteredItemState());

  Future<void> filterItem({String? categoryId}) async {
    emit(state.copyWith(loading: true, selectedCategoryId: categoryId));

    expireItemsSubscription?.cancel();
    expireItemsSubscription =
        _expireRepository.listenExpireItems(categoryId: categoryId).listen(
      (either) {
        emit(either.fold(
          (error) => state.copyWith(
            errorMessage: error.message,
            items: [],
            loading: false,
          ),
          (success) => state.copyWith(
            items: success,
            loading: false,
          ),
        ));
      },
    );
  }

  @override
  Future<void> close() async {
    await expireItemsSubscription?.cancel();

    return super.close();
  }
}

@freezed
class FilteredItemState with _$FilteredItemState {
  const factory FilteredItemState({
    @Default(false) bool loading,
    @Default(null) String? selectedCategoryId,
    @Default([]) List<ExpireItemModel> items,
    @Default("") String errorMessage,
  }) = _FilteredItemState;
}