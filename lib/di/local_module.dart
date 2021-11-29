import 'package:expireance/common/constants/box_constants.dart';
import 'package:expireance/data/local/expire_item_entity.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class LocalModule {
  static void inject() {
    Get.put<Box<ExpireItemEntity>>(
      Hive.box(BoxConstants.EXPIRE_ITEMS_BOX),
    );
  }
}
