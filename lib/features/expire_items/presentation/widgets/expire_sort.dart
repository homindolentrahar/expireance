import 'package:expireance/core/presentation/tiles.dart';
import 'package:expireance/core/presentation/buttons.dart';
import 'package:expireance/features/expire_items/presentation/application/expire_watcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Map<ExpireItemSort, String> expireItemSortName = {
  ExpireItemSort.all: "All",
  ExpireItemSort.name: "Name",
  ExpireItemSort.expired: "Expired"
};

class ExpireSort extends StatelessWidget {
  final ExpireItemSort sortingRule;
  final ValueChanged<ExpireItemSort> setSortingRule;

  const ExpireSort({
    Key? key,
    required this.sortingRule,
    required this.setSortingRule,
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
      ],
    ).marginSymmetric(horizontal: 16);
  }
}
