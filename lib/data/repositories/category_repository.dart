import 'package:dartz/dartz.dart';
import 'package:expireance/common/error/app_error.dart';
import 'package:expireance/data/local/expire_category_entity.dart';
import 'package:expireance/domain/models/expire_category_model.dart';
import 'package:expireance/domain/repositories/i_category_repository.dart';
import 'package:hive/hive.dart';

class CategoryRepository implements ICategoryRepository {
  final Box<ExpireCategoryEntity> _categoryBox;

  CategoryRepository({required Box<ExpireCategoryEntity> box})
      : _categoryBox = box;

  @override
  Either<AppError, List<ExpireCategoryModel>> fetchAllCategory() {
    try {
      final result = _categoryBox.values.map((cat) => cat.toModel()).toList();

      return right(result);
    } on Exception catch (err) {
      return left(AppError(err.toString()));
    }
  }

  @override
  Either<AppError, ExpireCategoryModel> fetchSingleCategory(String id) {
    try {
      final result = _categoryBox
          .get(id, defaultValue: ExpireCategoryEntity.empty())
          ?.toModel();

      return right(result!);
    } on Exception catch (err) {
      return left(AppError(err.toString()));
    }
  }

  @override
  Future<Either<AppError, Unit>> deleteCategory(String id) async {
    try {
      await _categoryBox.delete(id);

      return right(unit);
    } on Exception catch (err) {
      return left(AppError(err.toString()));
    }
  }

  @override
  Future<Either<AppError, Unit>> populateInitialCategory(
      List<ExpireCategoryModel> models) async {
    try {
      final mapEntries = models.asMap().map(
            (key, value) => MapEntry(
              value.id,
              ExpireCategoryEntity.fromModel(value),
            ),
          );
      await _categoryBox.putAll(mapEntries);

      return right(unit);
    } on Exception catch (err) {
      return left(AppError(err.toString()));
    }
  }

  @override
  Future<Either<AppError, Unit>> storeCategory(
      ExpireCategoryModel model) async {
    try {
      await _categoryBox.put(model.id, ExpireCategoryEntity.fromModel(model));

      return right(unit);
    } on Exception catch (err) {
      return left(AppError(err.toString()));
    }
  }

  @override
  Future<Either<AppError, Unit>> updateCategory(
      String id, ExpireCategoryModel model) async {
    try {
      await _categoryBox.put(id, ExpireCategoryEntity.fromModel(model));

      return right(unit);
    } on Exception catch (err) {
      return left(AppError(err.toString()));
    }
  }
}
