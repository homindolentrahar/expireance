import 'package:dartz/dartz.dart';
import 'package:expireance/common/error/app_error.dart';
import 'package:expireance/data/local/expire_item_entity.dart';

abstract class IExpireRepository {
  Either<AppError, List<ExpireItemEntity>> fetchExpireItems();

  Either<AppError, ExpireItemEntity> fetchSingleExpireItem({
    required String id,
  });

  Future<Either<AppError, Unit>> storeExpireItem({
    required ExpireItemEntity entity,
  });

  Future<Either<AppError, Unit>> updateExpireItem({
    required String id,
    required ExpireItemEntity entity,
  });

  Future<Either<AppError, Unit>> deleteExpireItem({
    required String id,
  });
}
