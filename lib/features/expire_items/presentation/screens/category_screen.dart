import 'package:expireance/features/expire_items/presentation/controllers/category_controller.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_category.dart';
import 'package:expireance/core/presentation/buttons.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  static const route = "/category";

  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late CategoryController _controller;

  @override
  void initState() {
    _controller = Get.find<CategoryController>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categoryId = Get.arguments?.toString();

    if (categoryId != null) {
      _controller.setSelectedCategory(categoryId);
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconBackButton(
            followedAction: () {
              _controller.clearSelectedCategory();
            },
          ),
          title: Text(
            "Expire Categories",
            style: Get.textTheme.headline6,
          ),
        ),
        body: GetX<CategoryController>(
          init: _controller
            ..fetchCategories()
            ..listenFilteredItems(categoryId: categoryId),
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: controller.categories.map((cat) {
                        return ExpireCategoryBadge(
                          model: cat,
                          selected: controller.selectedCategory == cat.id,
                          selectCategory: (category) {
                            if (category.id == controller.selectedCategory) {
                              controller.clearSelectedCategory();

                              controller.listenFilteredItems();
                            } else {
                              controller.setSelectedCategory(category.id);

                              controller.listenFilteredItems(
                                categoryId: category.id,
                              );
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.filteredItems.length,
                      itemBuilder: (ctx, index) {
                        final model = controller.filteredItems[index];

                        return ExpireItemList(model: model);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
