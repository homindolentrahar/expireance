import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_category_repository.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_actor.freezed.dart';

class CategoryActor extends Cubit<CategoryActorState> {
  final ICategoryRepository _categoryRepository;
  final IExpireRepository _expireRepository;

  CategoryActor(
    this._categoryRepository,
    this._expireRepository,
  ) : super(const CategoryActorState.initial());

  Future<void> addCategory(CategoryModel model) async {
    emit(const CategoryActorState.loading());

    final result = await _categoryRepository.storeCategory(model);

    emit(
      result.fold(
        (error) => CategoryActorState.error(error.message),
        (_) =>
            const CategoryActorState.success("Category stored successfully!"),
      ),
    );
  }

  Future<void> updateCategory(String id, CategoryModel model) async {
    emit(const CategoryActorState.loading());

    final result = await _categoryRepository.updateCategory(id, model);

    emit(
      result.fold(
        (error) => CategoryActorState.error(error.message),
        (_) {
          final updatedCategory = _categoryRepository
              .fetchAllCategory()
              .getOrElse(() => [])
              .where((item) => item.slug == model.slug)
              .first;

          _expireRepository.updateCategorizedExpireItem(
            categoryId: id,
            category: updatedCategory,
          );

          return const CategoryActorState.success(
              "Category updated successfully!");
        },
      ),
    );
  }

  Future<void> deleteCategory(String id) async {
    emit(const CategoryActorState.loading());

    final result = await _categoryRepository.deleteCategory(id);

    emit(
      result.fold(
        (error) => CategoryActorState.error(error.message),
        (_) {
          // Updating expire items with deleted category
          final uncategorizedCategory = _categoryRepository
              .fetchAllCategory()
              .getOrElse(() => [])
              .where((item) => item.slug == "uncategorized")
              .first;

          _expireRepository.updateCategorizedExpireItem(
            categoryId: id,
            category: uncategorizedCategory,
          );

          return const CategoryActorState.success(
            "Category deleted successfully!",
          );
        },
      ),
    );
  }
}

@freezed
class CategoryActorState with _$CategoryActorState {
  const factory CategoryActorState.initial() = _Initial;

  const factory CategoryActorState.loading() = _Loading;

  const factory CategoryActorState.success(String message) = _Success;

  const factory CategoryActorState.error(String message) = _Error;
}
