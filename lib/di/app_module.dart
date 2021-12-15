import 'package:expireance/common/constants/box_constants.dart';
import 'package:expireance/data/local/expire_category_entity.dart';
import 'package:expireance/data/local/expire_item_entity.dart';
import 'package:expireance/data/repositories/category_repository.dart';
import 'package:expireance/di/local_module.dart';
import 'package:expireance/domain/models/expire_category_model.dart';
import 'package:expireance/domain/repositories/i_category_repository.dart';
import 'package:get/get.dart';
import 'package:expireance/data/repositories/expire_repository.dart';
import 'package:expireance/domain/repositories/i_expire_repository.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AppModule {
  static registerAdapters() {
    Hive.registerAdapter(ExpireItemEntityAdapter(), override: true);
    Hive.registerAdapter(ExpireCategoryEntityAdapter(), override: true);
  }

  static Future<void> openBoxes() async {
    await Hive.close();

    await Hive.openBox<ExpireItemEntity>(BoxConstants.EXPIRE_ITEMS_BOX);
    await Hive.openBox<ExpireCategoryEntity>(
      BoxConstants.EPXIRE_CATEGORIES_BOX,
    );
  }

  static void _populateInitialCategory(ICategoryRepository repository) {
    final List<ExpireCategoryModel> categoryModels = [];
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
      final model = ExpireCategoryModel(
        id: id,
        slug: cat.toLowerCase(),
        name: cat,
      );

      categoryModels.add(model);
    }

    repository.populateInitialCategory(categoryModels);
  }

  static void _populateData() {
    final categoryBox = Hive.box<ExpireCategoryEntity>(
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
      CategoryRepository(box: Get.find<Box<ExpireCategoryEntity>>()),
    );

    _populateData();
  }
}
