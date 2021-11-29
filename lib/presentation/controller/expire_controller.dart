import 'package:get/get.dart';
import 'package:expireance/presentation/widgets/flashbar.dart';
import 'package:expireance/presentation/widgets/loading.dart';
import 'package:expireance/domain/models/expire_item_model.dart';
import 'package:expireance/domain/repositories/i_expire_repository.dart';

class ExpireController extends GetxController {
  final IExpireRepository _repository;

  ExpireController({required IExpireRepository repository})
      : _repository = repository;

  RxList<ExpireItemModel> expireItems = <ExpireItemModel>[].obs;

  void fetchExpireItems() {
    final result = _repository.fetchExpireItems();

    result.fold(
      (error) {
        Flashbar(
          context: Get.context!,
          title: "Something went wrong!",
          content: error.message,
          type: FlashbarType.ERROR,
        ).flash();
        printError(info: error.message);
      },
      (list) {
        expireItems.value = list;
      },
    );
  }

  void fetchSingleExpireItem(String id) {
    Loading.load();

    final result = _repository.fetchSingleExpireItem(id: id);

    result.fold(
      (error) {
        Flashbar(
          context: Get.context!,
          title: "Something went wrong!",
          content: error.message,
          type: FlashbarType.ERROR,
        ).flash();
      },
      (data) {},
    );
  }

  Future<void> storeExpireItem(ExpireItemModel model) async {
    Loading.load();

    final result = await _repository.storeExpireItem(model: model);

    result.fold(
      (error) {
        Flashbar(
          context: Get.context!,
          title: "Something went wrong!",
          content: error.message,
          type: FlashbarType.ERROR,
        ).flash();
      },
      (_) {
        Flashbar(
          context: Get.context!,
          title: "Expire item stored!",
          content: "Success storing item to the box",
          type: FlashbarType.SUCCESS,
        ).flash();
      },
    );
  }

  Future<void> updateExpireItem(String id, ExpireItemModel model) async {
    Loading.load();

    final result = await _repository.updateExpireItem(
      id: id,
      model: model,
    );

    result.fold(
      (error) {
        Flashbar(
          context: Get.context!,
          title: "Something went wrong!",
          content: error.message,
          type: FlashbarType.ERROR,
        ).flash();
      },
      (_) {
        Flashbar(
          context: Get.context!,
          title: "Expire item updated!",
          content: "Success updating item in the box",
          type: FlashbarType.SUCCESS,
        ).flash();
      },
    );
  }

  Future<void> deleteExpireItem(String id) async {
    Loading.load();

    final result = await _repository.deleteExpireItem(id: id);

    result.fold(
      (error) {
        Flashbar(
          context: Get.context!,
          title: "Something went wrong!",
          content: error.message,
          type: FlashbarType.ERROR,
        ).flash();
      },
      (_) {
        Flashbar(
          context: Get.context!,
          title: "Expire item deleted!",
          content: "Success deleting item from the box",
          type: FlashbarType.SUCCESS,
        ).flash();
      },
    );
  }
}
