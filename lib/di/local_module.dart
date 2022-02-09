import 'package:expireance/common/constants/box_constants.dart';
import 'package:expireance/di/app_module.dart';
import 'package:expireance/features/expire_items/data/local/category_entity.dart';
import 'package:expireance/features/expire_items/data/local/expire_item_entity.dart';
import 'package:expireance/features/settings/data/local/settings_entity.dart';
import 'package:hive/hive.dart';

class LocalModule {
  static void inject() {
    // Get It injection
    injector.registerLazySingleton<Box<SettingsEntity>>(
      () => Hive.box(BoxConstants.settingsBox),
    );
    injector.registerLazySingleton<Box<ExpireItemEntity>>(
      () => Hive.box(BoxConstants.expireItemBox),
    );
    injector.registerLazySingleton<Box<CategoryEntity>>(
      () => Hive.box(BoxConstants.expireCategoryBox),
    );
  }
}
