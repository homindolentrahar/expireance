import 'package:expireance/domain/models/expire_category_model.dart';
import 'package:expireance/presentation/widgets/core/buttons.dart';
import 'package:expireance/presentation/widgets/core/tiles.dart';
import 'package:expireance/presentation/widgets/expire/expire_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ExpireItemSort { all, name, expired }

const Map<ExpireItemSort, String> expireItemSortName = {
  ExpireItemSort.all: "All",
  ExpireItemSort.name: "Name",
  ExpireItemSort.expired: "Expired"
};

class ExpireSort extends StatelessWidget {
  final ExpireItemSort sortingRule;
  final String categoryFilteringRule;
  final List<ExpireCategoryModel> categories;
  final ValueChanged<ExpireItemSort> setSortingRule;
  final ValueChanged<ExpireCategoryModel> setCategoryFilteringRule;

  const ExpireSort({
    Key? key,
    required this.sortingRule,
    required this.categoryFilteringRule,
    required this.categories,
    required this.setSortingRule,
    required this.setCategoryFilteringRule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              sortingRule == ExpireItemSort.all
                  ? "All Items"
                  : sortingRule == ExpireItemSort.expired
                      ? "Expired Items"
                      : "By Name",
              style: TextStyle(
                color: Get.theme.primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            SortButton(
              onPressed: () {
                Get.bottomSheet(
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: ExpireItemSort.values.length,
                    itemBuilder: (ctx, index) {
                      return TextTiles(
                        title:
                            expireItemSortName[ExpireItemSort.values[index]] ??
                                "No Name",
                        selected: ExpireItemSort.values[index] == sortingRule,
                        onTap: () => setSortingRule(
                          ExpireItemSort.values.firstWhere(
                            (sort) {
                              return sort == ExpireItemSort.values[index];
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  backgroundColor: Get.theme.canvasColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              },
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: categories.map((category) {
                    return ExpireCategoryBadge(
                      model: category,
                      selected: categoryFilteringRule == category.id,
                      selectCategory: (selected) =>
                          setCategoryFilteringRule(selected),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
