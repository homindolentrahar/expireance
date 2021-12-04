import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expireance/common/error/app_error.dart';
import 'package:expireance/data/local/expire_item_entity.dart';
import 'package:expireance/domain/models/expire_item_model.dart';
import 'package:expireance/domain/repositories/i_expire_repository.dart';

class ExpireRepository implements IExpireRepository {
  final Box<ExpireItemEntity> _expireItemBox;

  ExpireRepository({
    required Box<ExpireItemEntity> box,
  }) : _expireItemBox = box;

  @override
  Stream<Either<AppError, List<ExpireItemModel>>> listenExpireItems() async* {
    yield* _expireItemBox
        .watch()
        .map(
          (event) {
            log("Event ID: ${event.key}\nEvent value: ${event.value}");

            final expireItems =
                _expireItemBox.values.map((item) => item.toModel()).toList();
            return right<AppError, List<ExpireItemModel>>(expireItems);
          },
        )
        .onErrorReturnWith(
          (error, _) => left(AppError(error.toString())),
        )
        .startWith(
          right<AppError, List<ExpireItemModel>>(
            _expireItemBox.values.map((item) => item.toModel()).toList(),
          ),
        );
  }

  @override
  Either<AppError, List<ExpireItemModel>> fetchExpireItems() {
    try {
      final result =
          _expireItemBox.values.map((item) => item.toModel()).toList();

      return right(result);
    } on Exception catch (error) {
      return left(AppError(error.toString()));
    }
  }

  @override
  Either<AppError, ExpireItemModel> fetchSingleExpireItem(
      {required String id}) {
    try {
      final result = _expireItemBox
          .get(id, defaultValue: ExpireItemEntity.empty())
          ?.toModel();

      return right(result!);
    } on Exception catch (error) {
      return left(AppError(error.toString()));
    }
  }

  @override
  Future<Either<AppError, Unit>> storeExpireItem(
      {required ExpireItemModel model}) async {
    try {
      await _expireItemBox.put(model.id, ExpireItemEntity.fromModel(model));

      return right(unit);
    } on Exception catch (error) {
      return left(AppError(error.toString()));
    }
  }

  @override
  Future<Either<AppError, Unit>> updateExpireItem(
      {required String id, required ExpireItemModel model}) async {
    try {
      await _expireItemBox.put(id, ExpireItemEntity.fromModel(model));

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
