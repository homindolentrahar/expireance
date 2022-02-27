import 'package:expireance/di/app_module.dart';
import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:expireance/features/expire_items/domain/models/expire_item_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'expire_form_controller.freezed.dart';

enum ExpireFormError { category, expireDate }

class ExpireFormController extends Cubit<ExpireFormState> {
  ExpireFormController() : super(const ExpireFormState());

  void populateInitialData(ExpireItemModel model) {
    emit(
      state.copyWith(
        image: model.image,
        name: model.name,
        amount: model.amount,
        category: model.category,
        desc: model.desc,
        expireDate: model.date.toIso8601String(),
      ),
    );
  }

  void imageChanged(String? imagePath) {
    emit(state.copyWith(image: imagePath ?? ""));
  }

  Future<void> setImage(ImageSource source) async {
    final imagePicker = injector.get<ImagePicker>();
    final image = await imagePicker.pickImage(source: source);

    if (image == null) {
      emit(state.copyWith(image: ""));
    } else {
      emit(state.copyWith(image: image.path));
    }
  }

  void clearImage() {
    emit(state.copyWith(image: ""));
  }

  void validate() {
    final isValid = state.category != null && state.expireDate.isNotEmpty;
    emit(state.copyWith(formValid: isValid));
  }

  void runValidation() {
    emit(state.copyWith(runValidation: true));
  }

  void addErrors(ExpireFormError error, String message) {
    if (error == ExpireFormError.category) {
      emit(state.copyWith(categoryErrorMsg: message));
    } else if (error == ExpireFormError.expireDate) {
      emit(state.copyWith(expireDateErrorMsg: message));
    } else {
      emit(state);
    }
  }

  void removeErrors(ExpireFormError error) {
    if (error == ExpireFormError.category) {
      emit(state.copyWith(categoryErrorMsg: ""));
    } else if (error == ExpireFormError.expireDate) {
      emit(state.copyWith(expireDateErrorMsg: ""));
    } else {
      emit(state);
    }
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: value));
  }

  void amountChanged(int value) {
    emit(state.copyWith(amount: value));
  }

  void categoryChanged(CategoryModel value) {
    emit(state.copyWith(category: value));
  }

  void descChanged(String value) {
    emit(state.copyWith(desc: value));
  }

  void expireChanged(DateTime value) {
    emit(state.copyWith(expireDate: value.toIso8601String()));
  }
}

@freezed
class ExpireFormState with _$ExpireFormState {
  const factory ExpireFormState({
    @Default("") String image,
    @Default("") String name,
    @Default(1) int amount,
    @Default(null) CategoryModel? category,
    @Default("") String desc,
    @Default("") String expireDate,
    @Default(false) bool formValid,
    @Default(false) bool runValidation,
    @Default("") String categoryErrorMsg,
    @Default("") String expireDateErrorMsg,
  }) = _ExpireFormState;
}
