import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:expireance/features/expire_items/data/local/expire_item_entity.dart';
import 'package:expireance/features/expire_items/domain/models/expire_item_model.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:expireance/utils/image_utlis.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expireance/common/error/app_error.dart';

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
  Stream<Either<AppError, List<ExpireItemModel>>> listenExpireItemsByCategory(
      {required String categoryId}) async* {
    yield* _expireItemBox
        .watch()
        .map(
          (event) {
            log("Event ID: ${event.key}\nEvent value: ${event.value}");

            final expireItems = _expireItemBox.values
                .map((item) => item.toModel())
                .where((item) => item.category.id == categoryId)
                .toList();
            return right<AppError, List<ExpireItemModel>>(expireItems);
          },
        )
        .onErrorReturnWith(
          (error, _) => left(AppError(error.toString())),
        )
        .startWith(
          right<AppError, List<ExpireItemModel>>(
            _expireItemBox.values
                .map((item) => item.toModel())
                .where((item) => item.category.id == categoryId)
                .toList(),
          ),
        );
  }

  @override
  Stream<Either<AppError, List<ExpireItemModel>>> searchExpireItems({
    required String query,
  }) async* {
    yield* _expireItemBox
        .watch()
        .map((event) {
          log("Event ID: ${event.key}\nEvent value: ${event.value}");

          final searchedExpireItems = _expireItemBox.values
              .map((item) => item.toModel())
              .where((item) =>
                  item.name.toLowerCase().contains(query.toLowerCase()))
              .toList();

          return right<AppError, List<ExpireItemModel>>(searchedExpireItems);
        })
        .onErrorReturnWith(
          (error, _) => left(AppError(error.toString())),
        )
        .startWith(
          right<AppError, List<ExpireItemModel>>(_expireItemBox.values
              .map((item) => item.toModel())
              .where((item) =>
                  item.name.toLowerCase().contains(query.toLowerCase()))
              .toList()),
        )
        .debounceTime(const Duration(milliseconds: 300));
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
      final expireModel = model;
      final imageName = expireModel.image.split("/").last;

      if (model.image.isNotEmpty) {
        final imageFile = await ImageUtils.storeImageToDevice(
          expireModel.image,
          imageName,
        );

        expireModel.image = imageFile.path;
      }

      await _expireItemBox.put(
        model.id,
        ExpireItemEntity.fromModel(expireModel),
      );

      return right(unit);
    } on Exception catch (error) {
      return left(AppError(error.toString()));
    }
  }

  @override
  Future<Either<AppError, Unit>> updateExpireItem(
      {required String id, required ExpireItemModel model}) async {
    try {
      final expireModel = model;
      final newImageName = expireModel.image.split("/").last;
      final savedImageName =
          _expireItemBox.get(id)?.image.split("/").last ?? "";

      if (expireModel.image.isNotEmpty) {
        if (savedImageName != newImageName) {
          final imageFile = await ImageUtils.updateImageAtDevice(
            expireModel.image,
            savedImageName,
            newImageName,
          );

          expireModel.image = imageFile.path;
        }
      } else {
        await ImageUtils.deleteImageFromDevice(newImageName);

        expireModel.image = "";
      }

      await _expireItemBox.put(id, ExpireItemEntity.fromModel(expireModel));

      return right(unit);
    } on Exception catch (error) {
      return left(AppError(error.toString()));
    }
  }

  @override
  Future<Either<AppError, Unit>> deleteExpireItem({required String id}) async {
    try {
      final savedImageName =
          _expireItemBox.get(id)?.image.split("/").last ?? "";

      await ImageUtils.deleteImageFromDevice(savedImageName);
      await _expireItemBox.delete(id);

      return right(unit);
    } on Exception catch (error) {
      return left(AppError(error.toString()));
    }
  }
}
