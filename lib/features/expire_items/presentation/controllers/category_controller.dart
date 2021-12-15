import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:expireance/common/error/app_error.dart';
import 'package:expireance/domain/models/expire_category_model.dart';
import 'package:expireance/domain/models/expire_item_model.dart';
import 'package:expireance/domain/repositories/i_category_repository.dart';
import 'package:expireance/domain/repositories/i_expire_repository.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final IExpireRepository _expireRepository;
  final ICategoryRepository _categoryRepository;

  CategoryController(
      {required IExpireRepository expireRepository,
      required ICategoryRepository categoryRepository})
      : _expireRepository = expireRepository,
        _categoryRepository = categoryRepository;

  final RxList<ExpireItemModel> _filteredItems = <ExpireItemModel>[].obs;
  final RxList<ExpireCategoryModel> _categories = <ExpireCategoryModel>[].obs;
  final RxList<ExpireCategoryModel> _primaryCategories =
      <ExpireCategoryModel>[].obs;
  final Rx<String> _selectedCategory = "".obs;

  List<ExpireItemModel> get filteredItems => _filteredItems;

  List<ExpireCategoryModel> get categories => _categories;

  List<ExpireCategoryModel> get primaryCategories => _primaryCategories;

  String get selectedCategory => _selectedCategory.value;

  void listenFilteredItems({String? categoryId}) {
    final Stream<Either<AppError, List<ExpireItemModel>>> result = categoryId ==
            null
        ? _expireRepository.listenExpireItems()
        : _expireRepository.listenExpireItemsByCategory(categoryId: categoryId);

    _filteredItems.bindStream(
      result.map(
        (either) => either.fold(
          (error) {
            log("Something went wrong: ${error.message}");

            return [];
          },
          (list) {
            return list;
          },
        ),
      ),
    );
  }

  void fetchCategories() {
    final result = _categoryRepository.fetchAllCategory();

    result.fold(
      (error) {
        log("Something went wrong: ${error.message}");
      },
      (list) {
        _categories.value = list;
      },
    );
  }

  void fetchPrimaryCategories() {
    final result = _categoryRepository.fetchAllCategory();

    result.fold(
      (error) {
        log("Something went wrong: ${error.message}");
      },
      (list) {
        _primaryCategories.value = list.take(6).toList();
      },
    );
  }

  void setSelectedCategory(String id) {
    _selectedCategory.value = id;
  }

  void clearSelectedCategory() {
    _selectedCategory.value = "";
  }
}
