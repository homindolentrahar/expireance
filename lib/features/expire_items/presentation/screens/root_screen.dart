import 'package:expireance/features/expire_items/presentation/fragments/expire_fragment.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_forms_sheet.dart';
import 'package:expireance/core/presentation/buttons.dart';
import 'package:flutter/material.dart';

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
        body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          pageSnapping: true,
          itemCount: rootMenu.length,
          itemBuilder: (ctx, index) => rootMenu[index],
        ),
        floatingActionButton: FAB(
          onPressed: () {
            ExpireFormsSheet.addExpireItem();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
