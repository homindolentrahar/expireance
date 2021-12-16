import 'package:expireance/common/constants/box_constants.dart';
import 'package:expireance/di/local_module.dart';
import 'package:expireance/features/expire_items/data/local/category_entity.dart';
import 'package:expireance/features/expire_items/data/local/expire_item_entity.dart';
import 'package:expireance/features/expire_items/data/repositories/category_repository.dart';
import 'package:expireance/features/expire_items/data/repositories/expire_repository.dart';
import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_category_repository.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AppModule {
  static registerAdapters() {
    Hive.registerAdapter(ExpireItemEntityAdapter(), override: true);
    Hive.registerAdapter(CategoryEntityAdapter(), override: true);
  }

  static Future<void> openBoxes() async {
    await Hive.close();

    await Hive.openBox<ExpireItemEntity>(BoxConstants.EXPIRE_ITEMS_BOX);
    await Hive.openBox<CategoryEntity>(
      BoxConstants.EPXIRE_CATEGORIES_BOX,
    );
  }

  static void _populateInitialCategory(ICategoryRepository repository) {
    final List<CategoryModel> categoryModels = [];
    final categories = <String>[
      "Food",
      "Beverage",
      "Spices",
      "Meat",
      "Dairy",
      "Veggies",
      "Fruits",
      "Meds",
      "Other"
    ];

    for (var cat in categories) {
      final id = "category_${const Uuid().v4()}";
      final model = CategoryModel(
        id: id,
        slug: cat.toLowerCase(),
        name: cat,
      );

      categoryModels.add(model);
    }

    repository.populateInitialCategory(categoryModels);
  }

  static void _populateData() {
    final categoryBox = Hive.box<CategoryEntity>(
      BoxConstants.EPXIRE_CATEGORIES_BOX,
    );
    final categoryRepository = Get.find<ICategoryRepository>();

    if (categoryBox.isEmpty) {
      _populateInitialCategory(categoryRepository);
    }
  }

  static void inject() {
    //General class injection
    Get.put<ImagePicker>(ImagePicker());

    LocalModule.inject();

    Get.put<IExpireRepository>(
      ExpireRepository(box: Get.find<Box<ExpireItemEntity>>()),
    );

    Get.put<ICategoryRepository>(
      CategoryRepository(box: Get.find<Box<CategoryEntity>>()),
    );

    _populateData();
  }
}
