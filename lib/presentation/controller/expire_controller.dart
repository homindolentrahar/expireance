import 'package:expireance/presentation/widgets/flashbar.dart';
import 'package:expireance/presentation/widgets/loading.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expireance/domain/models/expire_item_model.dart';
import 'package:expireance/domain/repositories/i_expire_repository.dart';

class ExpireController extends GetxController {
  final IExpireRepository _repository;

  ExpireController({required IExpireRepository repository})
      : _repository = repository;

  RxList<ExpireItemModel> expireItems = <ExpireItemModel>[].obs;

  void fetchExpireItems() {
    // showDialog(
    //   context: Get.context!,
    //   builder: (ctx) => Loading.load(),
    // );

    final result = _repository.fetchExpireItems();

    result.fold(
      (error) {
        // showFlash(
        //   context: Get.context!,
        //   duration: const Duration(seconds: 3),
        //   builder: (_, controller) {
        //     return Flashbar(
        //       type: FlashbarType.ERROR,
        //       controller: controller,
        //       title: "Something went wrong",
        //       content: error.message,
        //     ).flash();
        //   },
        // );
        printError(info: error.message);
      },
      (list) {
        expireItems.value = list;
      },
    );
  }

  void fetchSingleExpireItem(String id) {
    showDialog(
      context: Get.context!,
      builder: (ctx) => Loading.load(),
    );
    final result = _repository.fetchSingleExpireItem(id: id);

    result.fold(
      (error) {
        showFlash(
          context: Get.context!,
          duration: const Duration(seconds: 3),
          builder: (_, controller) {
            return Flashbar(
              type: FlashbarType.ERROR,
              controller: controller,
              title: "Something went wrong",
              content: error.message,
            ).flash();
          },
        );
      },
      (data) {},
    );
  }

  Future<void> storeExpireItem(ExpireItemModel model) async {
    showDialog(
      context: Get.context!,
      builder: (ctx) => Loading.load(),
    );
    final result = await _repository.storeExpireItem(model: model);

    result.fold(
      (error) {
        showFlash(
          context: Get.context!,
          duration: const Duration(seconds: 3),
          builder: (_, controller) {
            return Flashbar(
              type: FlashbarType.ERROR,
              controller: controller,
              title: "Something went wrong",
              content: error.message,
            ).flash();
          },
        );
      },
      (_) {
        showFlash(
          context: Get.context!,
          duration: const Duration(seconds: 3),
          builder: (_, controller) {
            return Flashbar(
              type: FlashbarType.SUCCESS,
              controller: controller,
              title: "Expire item added!",
              content: "Success adding expire item",
            ).flash();
          },
        );
      },
    );
  }

  Future<void> updateExpireItem(String id, ExpireItemModel model) async {
    // Show loading
    showDialog(
      context: Get.context!,
      builder: (ctx) => Loading.load(),
    );
    final result = await _repository.updateExpireItem(
      id: id,
      model: model,
    );

    result.fold(
      (error) {
        showFlash(
          context: Get.context!,
          duration: const Duration(seconds: 3),
          builder: (_, controller) {
            return Flashbar(
              type: FlashbarType.ERROR,
              controller: controller,
              title: "Something went wrong",
              content: error.message,
            ).flash();
          },
        );
      },
      (_) {
        showFlash(
          context: Get.context!,
          duration: const Duration(seconds: 3),
          builder: (_, controller) {
            return Flashbar(
              type: FlashbarType.SUCCESS,
              controller: controller,
              title: "Expire item updated!",
              content: "Success updating expire item",
            ).flash();
          },
        );
      },
    );
  }

  Future<void> deleteExpireItem(String id) async {
    // Show loading
    showDialog(
      context: Get.context!,
      builder: (ctx) => Loading.load(),
    );
    final result = await _repository.deleteExpireItem(id: id);

    result.fold(
      (error) {
        showFlash(
          context: Get.context!,
          duration: const Duration(seconds: 3),
          builder: (_, controller) {
            return Flashbar(
              type: FlashbarType.ERROR,
              controller: controller,
              title: "Something went wrong",
              content: error.message,
            ).flash();
          },
        );
      },
      (_) {
        showFlash(
          context: Get.context!,
          duration: const Duration(seconds: 3),
          builder: (_, controller) {
            return Flashbar(
              type: FlashbarType.SUCCESS,
              controller: controller,
              title: "Expire item deleted!",
              content: "Success deleting expire item",
            ).flash();
          },
        );
      },
    );
  }
}
