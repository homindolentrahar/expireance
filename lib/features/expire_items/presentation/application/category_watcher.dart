import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_category_repository.dart';

class CategoryWatcher extends Cubit<List<CategoryModel>> {
  final ICategoryRepository _categoryRepository;
  StreamSubscription? categoriesSubscription;

  CategoryWatcher(this._categoryRepository) : super([]);

  Future<void> listenCategories() async {
    await categoriesSubscription?.cancel();
    categoriesSubscription = _categoryRepository.listenAllCategory().listen(
          (either) => either.fold(
            (error) {
              log("Error: ${error.message}");

              return emit([]);
            },
            (success) => emit(
              success
                ..sort(
                  (a, b) => a.name.compareTo(b.name),
                ),
            ),
          ),
        );
  }

  @override
  Future<void> close() async {
    await categoriesSubscription?.cancel();

    return super.close();
  }
}

class SingleCategoryWatcher extends Cubit<CategoryModel?> {
  final ICategoryRepository _categoryRepository;
  final String id;

  SingleCategoryWatcher(this._categoryRepository, {required this.id})
      : super(null) {
    final result = _categoryRepository.fetchSingleCategory(id);

    emit(
      result.fold(
        (error) => null,
        (data) => data,
      ),
    );
  }
}
