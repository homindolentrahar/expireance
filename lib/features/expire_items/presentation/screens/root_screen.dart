import 'package:expireance/core/presentation/widgets/sheets.dart';
import 'package:expireance/features/expire_items/presentation/fragments/expire_fragment.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_forms.dart';
import 'package:expireance/core/presentation/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RootScreen extends StatelessWidget {
  static const route = "/";

  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const rootMenu = [
      ExpireFragment(),
    ];

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          pageSnapping: true,
          itemCount: rootMenu.length,
          itemBuilder: (ctx, index) => rootMenu[index],
        ),
        floatingActionButton: FAB(
          onPressed: () {
            showBarModalBottomSheet(
              context: context,
              bounce: true,
              topControl: const SheetIndicator(),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              builder: (ctx) => const AddExpireForm(),
              backgroundColor: Theme.of(context).canvasColor,
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
