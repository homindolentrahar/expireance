import 'package:expireance/core/presentation/widgets/buttons.dart';
import 'package:expireance/core/presentation/widgets/sheets.dart';
import 'package:expireance/core/presentation/widgets/tiles.dart';
import 'package:expireance/features/expire_items/presentation/application/expire_watcher.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
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
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SortButton(
                onPressed: () {
                  showBarModalBottomSheet(
                    context: context,
                    bounce: true,
                    expand: false,
                    enableDrag: false,
                    topControl: const SheetIndicator(),
                    backgroundColor: Theme.of(context).canvasColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        topLeft: Radius.circular(16),
                      ),
                    ),
                    builder: (ctx) => ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: ExpireItemSort.values.length,
                      itemBuilder: (ctx, index) {
                        return TextTiles(
                          title: expireItemSortName[
                                  ExpireItemSort.values[index]] ??
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
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
