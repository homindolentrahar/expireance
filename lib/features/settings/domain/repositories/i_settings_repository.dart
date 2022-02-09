import 'package:dartz/dartz.dart';
import 'package:expireance/common/error/app_error.dart';
import 'package:expireance/features/settings/domain/models/settings_model.dart';

abstract class ISettingsRepository {
  Either<AppError, SettingsModel> fetchSettings();

  Future<Either<AppError, Unit>> populateInitialSettings({
    required SettingsModel model,
  });

  Future<Either<AppError, Unit>> updateSettings({required SettingsModel model});
}
