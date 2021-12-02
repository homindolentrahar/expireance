import 'package:dartz/dartz.dart';
import 'package:expireance/common/error/app_error.dart';
import 'package:expireance/domain/models/expire_category_model.dart';

abstract class ICategoryRepository {
  Either<AppError, List<ExpireCategoryModel>> fetchAllCategory();

  Either<AppError, ExpireCategoryModel> fetchSingleCategory(String id);

  Future<Either<AppError, Unit>> populateInitialCategory(
    List<ExpireCategoryModel> models,
  );

  Future<Either<AppError, Unit>> storeCategory(ExpireCategoryModel model);

  Future<Either<AppError, Unit>> updateCategory(
    String id,
    ExpireCategoryModel model,
  );

  Future<Either<AppError, Unit>> deleteCategory(String id);
}
