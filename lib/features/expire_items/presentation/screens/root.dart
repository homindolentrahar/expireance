import 'package:expireance/features/expire_items/presentation/fragments/expire_fragment.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_sheets.dart';
import 'package:expireance/core/presentation/buttons.dart';
import 'package:flutter/material.dart';

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

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
            ExpireSheets.addExpireItem();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
