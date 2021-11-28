import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expireance/common/error/app_error.dart';
import 'package:expireance/data/local/expire_item_entity.dart';
import 'package:expireance/domain/repositories/i_expire_repository.dart';

class ExpireRepository implements IExpireRepository {
  final Box<ExpireItemEntity> _expireItemBox;

  ExpireRepository({required Box<ExpireItemEntity> box}) : _expireItemBox = box;

  @override
  Either<AppError, List<ExpireItemEntity>> fetchExpireItems() {
    try {
      final result = _expireItemBox.values.toList();

      return right(result);
    } on Exception catch (error) {
      return left(AppError(error.toString()));
    }
  }

  @override
  Either<AppError, ExpireItemEntity> fetchSingleExpireItem(
      {required String id}) {
    try {
      final result =
          _expireItemBox.get(id, defaultValue: ExpireItemEntity.empty());

      return right(result!);
    } on Exception catch (error) {
      return left(AppError(error.toString()));
    }
  }

  @override
  Future<Either<AppError, Unit>> storeExpireItem(
      {required ExpireItemEntity entity}) async {
    try {
      await _expireItemBox.put(entity.id, entity);

      return right(unit);
    } on Exception catch (error) {
      return left(AppError(error.toString()));
    }
  }

  @override
  Future<Either<AppError, Unit>> updateExpireItem(
      {required String id, required ExpireItemEntity entity}) async {
    try {
      await _expireItemBox.put(id, entity);

      return right(unit);
    } on Exception catch (error) {
      return left(AppError(error.toString()));
    }
  }

  @override
  Future<Either<AppError, Unit>> deleteExpireItem({required String id}) async {
    try {
      await _expireItemBox.delete(id);

      return right(unit);
    } on Exception catch (error) {
      return left(AppError(error.toString()));
    }
  }
}
