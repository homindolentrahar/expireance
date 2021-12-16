import 'package:dartz/dartz.dart';
import 'package:expireance/common/error/app_error.dart';
import 'package:expireance/features/expire_items/domain/models/category_model.dart';

abstract class ICategoryRepository {
  Either<AppError, List<CategoryModel>> fetchAllCategory();

  Either<AppError, CategoryModel> fetchSingleCategory(String id);

  Future<Either<AppError, Unit>> populateInitialCategory(
    List<CategoryModel> models,
  );

  Future<Either<AppError, Unit>> storeCategory(CategoryModel model);

  Future<Either<AppError, Unit>> updateCategory(
    String id,
    CategoryModel model,
  );

  Future<Either<AppError, Unit>> deleteCategory(String id);
}
