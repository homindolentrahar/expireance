import 'dart:developer';

import 'package:expireance/domain/models/expire_item_model.dart';
import 'package:expireance/domain/repositories/i_expire_repository.dart';
import 'package:get/get.dart';

class ExpireSearchController extends GetxController {
  final IExpireRepository _expireRepository;

  ExpireSearchController({required IExpireRepository expireRepository})
      : _expireRepository = expireRepository;

  RxList<ExpireItemModel> searchedExpireItems = <ExpireItemModel>[].obs;

  void searchExpireItems(String query) {
    searchedExpireItems.bindStream(
      _expireRepository.searchExpireItems(query: query).map(
            (either) => either.fold(
              (failure) {
                log(failure.message);

                return [];
              },
              (list) => list,
            ),
          ),
    );
  }

  void emptySearchedExpireItems() {
    searchedExpireItems.value = [];
  }
}
