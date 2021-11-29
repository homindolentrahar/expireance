import 'package:dartz/dartz.dart';
import 'package:expireance/common/error/app_error.dart';
import 'package:expireance/domain/models/expire_item_model.dart';

abstract class IExpireRepository {
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
