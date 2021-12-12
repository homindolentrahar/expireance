import 'dart:developer';

import 'package:expireance/domain/models/expire_category_model.dart';
import 'package:expireance/domain/repositories/i_category_repository.dart';
import 'package:expireance/presentation/widgets/expire/expire_sort.dart';
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
  RxList<ExpireItemModel> priorityExpireItems = <ExpireItemModel>[].obs;
  ExpireItemModel? singleExpireItem;
  RxList<ExpireCategoryModel> expireCategories = <ExpireCategoryModel>[].obs;

  //  Sorting and filtering
  final Rx<ExpireItemSort> _sortingRule = ExpireItemSort.all.obs;
  final Rx<String> _categoryFilteringRule = "".obs;
  final Rx<String> _searchQuery = "".obs;

  ExpireItemSort get sortingRule => _sortingRule.value;

  String get categoryFilteringRule => _categoryFilteringRule.value;

  String get searchQuery => _searchQuery.value;

  void setSortingRule(ExpireItemSort rule) {
    _sortingRule.value = rule;
  }

  void setCategoryFilteringRule(String id) {
    _categoryFilteringRule.value = id;
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  //  Main function
  void listenExpireItems() {
    expireItems.bindStream(
      _expireRepository.listenExpireItems().map(
            (either) => either.fold(
              (error) => [],
              (list) => list
                  .where(
                    (item) => _categoryFilteringRule.value.isNotEmpty
                        ? item.category.id == _categoryFilteringRule.value
                        : true,
                  )
                  .where(
                    (item) => _sortingRule.value == ExpireItemSort.expired
                        ? DateTime.now().isAfter(item.date)
                        : true,
                  )
                  .toList()
                ..sort((a, b) {
                  if (_sortingRule.value == ExpireItemSort.name) {
                    return a.name.compareTo(b.name);
                  } else {
                    return a.date.compareTo(b.date);
                  }
                }),
            ),
          ),
    );
  }

  void listenPriorityExpireItems() {
    priorityExpireItems.bindStream(
      _expireRepository.listenExpireItems().map(
            (either) => either.fold(
              (error) => [],
              (list) => list
                  .where(
                    (item) =>
                        item.date.difference(DateTime.now()).inDays <= 7 &&
                        item.date.difference(DateTime.now()).inHours > 1,
                  ) // A week before expired
                  .toList(),
            ),
          ),
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

  void clearSingleExpireItem() {
    singleExpireItem = null;
  }

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
