import 'package:expireance/features/settings/domain/models/settings_model.dart';
import 'package:hive/hive.dart';

part 'settings_entity.g.dart';

@HiveType(typeId: 2)
class SettingsEntity extends HiveObject {
  static const typeId = 2;

  @HiveField(0)
  bool enableNotification;

  SettingsEntity(this.enableNotification);

  factory SettingsEntity.empty() => SettingsEntity(
        false,
      );

  factory SettingsEntity.fromModel(SettingsModel model) {
    return SettingsEntity(model.enableNotification);
  }

  SettingsModel toModel() => SettingsModel(
        enableNotification: enableNotification,
      );
}
