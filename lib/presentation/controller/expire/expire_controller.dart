import 'dart:developer';

import 'package:expireance/domain/models/expire_category_model.dart';
import 'package:expireance/domain/repositories/i_category_repository.dart';
import 'package:get/get.dart';
import 'package:expireance/presentation/widgets/core/flashbar.dart';
import 'package:expireance/domain/models/expire_item_model.dart';
import 'package:expireance/domain/repositories/i_expire_repository.dart';

class ExpireController extends GetxController {
  final IExpireRepository _expireRepository;
  final ICategoryRepository _categoryRepository;

  ExpireController({
    required IExpireRepository expireRepository,
    required ICategoryRepository categoryRepository,
  })  : _expireRepository = expireRepository,
        _categoryRepository = categoryRepository;

  RxList<ExpireItemModel> expireItems = <ExpireItemModel>[].obs;
  ExpireItemModel? singleExpireItem;
  RxList<ExpireCategoryModel> expireCategories = <ExpireCategoryModel>[].obs;

  List<ExpireItemModel> get expirePriorities => expireItems
      .where((model) => model.date.difference(DateTime.now()).inDays <= 7)
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  void fetchCategories() {
    final result = _categoryRepository.fetchAllCategory();

    result.fold(
      (error) {
        Flashbar(
          context: Get.context!,
          title: "Something went wrong!",
          content: error.message,
          type: FlashbarType.ERROR,
        );
      },
      (list) {
        expireCategories.value = list;
      },
    );
  }

  void fetchExpireItems() {
    final result = _expireRepository.fetchExpireItems();

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
        expireItems.value = list
          ..sort((expA, expB) => expA.date.compareTo(expB.date));
      },
    );
  }

  void fetchSingleExpireItem(String id) {
    final result = _expireRepository.fetchSingleExpireItem(id: id);

    result.fold(
      (error) {
        Flashbar(
          context: Get.context!,
          title: "Something went wrong!",
          content: error.message,
          type: FlashbarType.ERROR,
        ).flash();
      },
      (data) {
        singleExpireItem = data;
      },
    );
  }

  Future<void> storeExpireItem(ExpireItemModel model) async {
    final result = await _expireRepository.storeExpireItem(model: model);

    result.fold(
      (error) {
        Flashbar(
          context: Get.context!,
          title: "Something went wrong!",
          content: error.message,
          type: FlashbarType.ERROR,
        ).flash();

        log("Error occured: ${error.message}");
      },
      (_) {},
    );
  }

  Future<void> updateExpireItem(String id, ExpireItemModel model) async {
    final result = await _expireRepository.updateExpireItem(
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
      (_) {},
    );
  }

  Future<void> deleteExpireItem(String id) async {
    final result = await _expireRepository.deleteExpireItem(id: id);

    result.fold(
      (error) {
        Flashbar(
          context: Get.context!,
          title: "Something went wrong!",
          content: error.message,
          type: FlashbarType.ERROR,
        ).flash();
      },
      (_) {},
    );
  }
}
