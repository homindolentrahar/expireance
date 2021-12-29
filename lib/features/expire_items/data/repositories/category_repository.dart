import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:expireance/common/error/app_error.dart';
import 'package:expireance/features/expire_items/data/local/category_entity.dart';
import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_category_repository.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

class CategoryRepository implements ICategoryRepository {
  final Box<CategoryEntity> _categoryBox;

  CategoryRepository({required Box<CategoryEntity> box}) : _categoryBox = box;

  @override
  Stream<Either<AppError, List<CategoryModel>>> listenAllCategory() async* {
    yield* _categoryBox
        .watch()
        .map(
          (event) {
            log("Event ID: ${event.key}\nEvent value: ${event.value}");

            final categories =
                _categoryBox.values.map((item) => item.toModel()).toList();

            return right<AppError, List<CategoryModel>>(categories);
          },
        )
        .onErrorReturnWith(
          (error, _) => left(AppError(error.toString())),
        )
        .startWith(
          right(_categoryBox.values.map((item) => item.toModel()).toList()),
        );
  }

  @override
  Either<AppError, List<CategoryModel>> fetchAllCategory() {
    try {
      final result = _categoryBox.values.map((cat) => cat.toModel()).toList();

      return right(result);
    } on Exception catch (err) {
      return left(AppError(err.toString()));
    }
  }

  @override
  Either<AppError, CategoryModel> fetchSingleCategory(String id) {
    try {
      final result =
          _categoryBox.get(id, defaultValue: CategoryEntity.empty())?.toModel();

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
      List<CategoryModel> models) async {
    try {
      final mapEntries = models.asMap().map(
            (key, value) => MapEntry(
              value.id,
              CategoryEntity.fromModel(value),
            ),
          );
      await _categoryBox.putAll(mapEntries);

      return right(unit);
    } on Exception catch (err) {
      return left(AppError(err.toString()));
    }
  }

  @override
  Future<Either<AppError, Unit>> storeCategory(CategoryModel model) async {
    try {
      await _categoryBox.put(model.id, CategoryEntity.fromModel(model));

      return right(unit);
    } on Exception catch (err) {
      return left(AppError(err.toString()));
    }
  }

  @override
  Future<Either<AppError, Unit>> updateCategory(
      String id, CategoryModel model) async {
    try {
      await _categoryBox.put(id, CategoryEntity.fromModel(model));

      return right(unit);
    } on Exception catch (err) {
      return left(AppError(err.toString()));
    }
  }
}
