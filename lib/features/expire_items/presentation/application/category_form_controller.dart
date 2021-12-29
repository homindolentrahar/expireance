import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_form_controller.freezed.dart';

class CategoryFormController extends Cubit<CategoryFormState> {
  CategoryFormController() : super(const CategoryFormState());

  void populateInitialData(CategoryModel model) {
    emit(state.copyWith(name: model.name));
  }

  void runValidation() {
    emit(state.copyWith(runValidation: true));
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: value));
  }
}

@freezed
class CategoryFormState with _$CategoryFormState {
  const factory CategoryFormState({
    @Default("") String name,
    @Default(false) bool runValidation,
  }) = _CategoryFormState;
}
