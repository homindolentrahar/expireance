import 'package:dartz/dartz.dart';
import 'package:expireance/common/error/app_error.dart';
import 'package:expireance/features/settings/data/local/settings_entity.dart';
import 'package:expireance/features/settings/domain/models/settings_model.dart';
import 'package:expireance/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsRepository implements ISettingsRepository {
  final Box<SettingsEntity> _box;

  SettingsRepository({required Box<SettingsEntity> box}) : _box = box;

  @override
  Either<AppError, SettingsModel> fetchSettings() {
    try {
      final result = _box.get(SettingsEntity.typeId) ?? SettingsEntity.empty();

      return right(result.toModel());
    } on Exception catch (error) {
      return left(AppError(error.toString()));
    }
  }

  @override
  Future<Either<AppError, Unit>> populateInitialSettings({
    required SettingsModel model,
  }) async {
    try {
      await _box.put(
        SettingsEntity.typeId,
        SettingsEntity.fromModel(model),
      );

      return right(unit);
    } on Exception catch (error) {
      return left(AppError(error.toString()));
    }
  }

  @override
  Future<Either<AppError, Unit>> updateSettings({
    required SettingsModel model,
  }) async {
    try {
      await _box.put(
        SettingsEntity.typeId,
        SettingsEntity.fromModel(model),
      );

      return right(unit);
    } on Exception catch (error) {
      return left(AppError(error.toString()));
    }
  }
}
