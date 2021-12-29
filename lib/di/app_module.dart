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
import 'package:expireance/utils/app_utils.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

final injector = GetIt.instance;

class AppModule {
  static registerAdapters() {
    Hive.registerAdapter(ExpireItemEntityAdapter(), override: true);
    Hive.registerAdapter(CategoryEntityAdapter(), override: true);
  }

  static Future<void> openBoxes() async {
    await Hive.close();

    await Hive.openBox<ExpireItemEntity>(BoxConstants.expireItemBox);
    await Hive.openBox<CategoryEntity>(
      BoxConstants.expireCategoryBox,
    );
  }

  static List<CategoryModel> getInitialCategories() => [
        "Food",
        "Beverage",
        "Spices",
        "Meat",
        "Dairy",
        "Veggies",
        "Fruits",
        "Meds",
        "Other"
      ]
          .map((name) => CategoryModel(
                id: "category_${const Uuid().v4()}",
                slug: AppUtils.createSlug(name),
                name: name,
              ))
          .toList();

  static void inject() {
    //  Get It injection
    LocalModule.inject();

    //  General
    injector.registerLazySingleton<ImagePicker>(() => ImagePicker());

    //  Repositories
    injector.registerLazySingleton<IExpireRepository>(
      () => ExpireRepository(box: injector.get<Box<ExpireItemEntity>>()),
    );
    injector.registerLazySingleton<ICategoryRepository>(
      () => CategoryRepository(box: injector.get<Box<CategoryEntity>>()),
    );

    //  Controllers
    injector.registerLazySingleton<CategoryWatcher>(
      () => CategoryWatcher(injector.get<ICategoryRepository>()),
    );

    //  Populate initial category
    final categoryBox = injector.get<Box<CategoryEntity>>();

    if (categoryBox.isEmpty) {
      injector
          .get<ICategoryRepository>()
          .populateInitialCategory(getInitialCategories());
    }
  }
}
