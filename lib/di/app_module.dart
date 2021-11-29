import 'dart:typed_data';

import 'package:expireance/common/constants/box_constants.dart';
import 'package:expireance/data/local/expire_item_entity.dart';
import 'package:expireance/di/local_module.dart';
import 'package:get/get.dart';
import 'package:expireance/data/repositories/expire_repository.dart';
import 'package:expireance/domain/repositories/i_expire_repository.dart';
import 'package:expireance/presentation/controller/expire_controller.dart';
import 'package:hive/hive.dart';

class AppModule {
  static registerAdapters() {
    Hive.registerAdapter(ExpireItemEntityAdapter(), override: true);
  }

  static Future<void> openBoxes() async {
    await Hive.openBox<ExpireItemEntity>(BoxConstants.EXPIRE_ITEMS_BOX);

    final box = Hive.box<ExpireItemEntity>(BoxConstants.EXPIRE_ITEMS_BOX);

    _populateInitialDummy(box);
  }

  static void _populateInitialDummy(Box<ExpireItemEntity> box) {
    box.put(
      "0",
      ExpireItemEntity(
        "id0",
        "First Item",
        "Desc of first Item",
        10,
        DateTime.now().toIso8601String(),
        Uint8List(0),
        "category0",
      ),
    );
    box.put(
      "1",
      ExpireItemEntity(
        "id1",
        "Second Item",
        "Desc of second Item",
        20,
        DateTime.now().toIso8601String(),
        Uint8List(0),
        "category0",
      ),
    );
    box.put(
      "2",
      ExpireItemEntity(
        "id2",
        "Third Item",
        "Desc of third Item",
        9,
        DateTime.now().toIso8601String(),
        Uint8List(0),
        "category0",
      ),
    );
  }

  static void inject() {
    LocalModule.inject();

    Get.put<IExpireRepository>(
      ExpireRepository(expireItemBox: Get.find<Box<ExpireItemEntity>>()),
    );

    Get.lazyPut<ExpireController>(
      () => ExpireController(
        repository: Get.find<IExpireRepository>(),
      ),
    );
  }
}
