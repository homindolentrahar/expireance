import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_category_repository.dart';

class CategoryWatcher extends Cubit<List<CategoryModel>> {
  final ICategoryRepository _categoryRepository;

  CategoryWatcher(this._categoryRepository) : super([]) {
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
