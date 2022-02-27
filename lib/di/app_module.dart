import 'package:expireance/common/constants/box_constants.dart';
import 'package:expireance/di/local_module.dart';
import 'package:expireance/features/expire_items/data/local/category_entity.dart';
import 'package:expireance/features/expire_items/data/local/expire_item_entity.dart';
import 'package:expireance/features/expire_items/data/repositories/category_repository.dart';
import 'package:expireance/features/expire_items/data/repositories/expire_repository.dart';
import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_category_repository.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:expireance/features/expire_items/presentation/application/category_watcher.dart';
import 'package:expireance/features/settings/data/local/settings_entity.dart';
import 'package:expireance/features/settings/data/repositories/settings_repository.dart';
import 'package:expireance/features/settings/domain/models/settings_model.dart';
import 'package:expireance/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:expireance/utils/app_utils.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

final injector = GetIt.instance;

class AppModule {
  static registerAdapters() {
    Hive.registerAdapter(SettingsEntityAdapter(), override: true);
    Hive.registerAdapter(ExpireItemEntityAdapter(), override: true);
    Hive.registerAdapter(CategoryEntityAdapter(), override: true);
  }

  static Future<void> openBoxes() async {
    await Hive.close();

    await Hive.openBox<SettingsEntity>(BoxConstants.settingsBox);
    await Hive.openBox<ExpireItemEntity>(BoxConstants.expireItemBox);
    await Hive.openBox<CategoryEntity>(BoxConstants.expireCategoryBox);
    await Hive.openBox<String>(BoxConstants.lostDataBox);
  }

  static void inject() {
    //  Get It injection
    LocalModule.inject();

    //  General
    injector.registerLazySingleton<ImagePicker>(() => ImagePicker());

    //  Repositories
    injector.registerLazySingleton<ISettingsRepository>(
      () => SettingsRepository(box: injector.get<Box<SettingsEntity>>()),
    );
    injector.registerLazySingleton<IExpireRepository>(
      () => ExpireRepository(
        box: injector.get<Box<ExpireItemEntity>>(),
        lostDataBox: injector.get<Box<String>>(
          instanceName: BoxConstants.lostDataBox,
        ),
      ),
    );
    injector.registerLazySingleton<ICategoryRepository>(
      () => CategoryRepository(box: injector.get<Box<CategoryEntity>>()),
    );

    //  Controllers
    injector.registerLazySingleton<CategoryWatcher>(
      () => CategoryWatcher(injector.get<ICategoryRepository>()),
    );

    //  Populate initial data
    final settingsBox = injector.get<Box<SettingsEntity>>();
    final categoryBox = injector.get<Box<CategoryEntity>>();

    if (settingsBox.isEmpty) {
      injector.get<ISettingsRepository>().populateInitialSettings(
            model: SettingsModel(enableNotification: false),
          );
    }

    if (categoryBox.isEmpty) {
      final initialCategories = [
        "Food",
        "Beverage",
        "Spices",
        "Meat",
        "Dairy",
        "Veggies",
        "Fruits",
        "Meds",
        "Uncategorized"
      ]
          .map(
            (name) => CategoryModel(
              id: "category_${const Uuid().v4()}",
              slug: AppUtils.createSlug(name),
              name: name,
            ),
          )
          .toList();

      injector
          .get<ICategoryRepository>()
          .populateInitialCategory(initialCategories);
    }
  }
}
