import 'package:dartz/dartz.dart';
import 'package:expireance/common/error/app_error.dart';
import 'package:expireance/features/expire_items/domain/models/expire_item_model.dart';

abstract class IExpireRepository {
  Stream<Either<AppError, List<ExpireItemModel>>> listenExpireItems();

  Stream<Either<AppError, List<ExpireItemModel>>> listenExpireItemsByCategory({
    required String categoryId,
  });

  Stream<Either<AppError, List<ExpireItemModel>>> searchExpireItems({
    required String query,
  });

  Either<AppError, List<ExpireItemModel>> fetchExpireItems();

  Either<AppError, ExpireItemModel> fetchSingleExpireItem({
    required String id,
  });

  Future<Either<AppError, Unit>> storeExpireItem({
    required ExpireItemModel model,
  });

  Future<Either<AppError, Unit>> updateExpireItem({
    required String id,
    required ExpireItemModel model,
  });

  Future<Either<AppError, Unit>> deleteExpireItem({
    required String id,
  });
}
