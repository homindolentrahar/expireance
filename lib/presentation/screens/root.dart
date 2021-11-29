import 'package:expireance/presentation/fragments/expire_fragment.dart';
import 'package:expireance/presentation/fragments/shop_fragment.dart';
import 'package:expireance/presentation/widgets/fab.dart';
import 'package:flutter/material.dart';

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const rootMenu = [
      ExpireFragment(),
      ShopFragment(),
    ];

    return SafeArea(
      child: Scaffold(
        body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          pageSnapping: true,
          itemCount: rootMenu.length,
          itemBuilder: (ctx, index) => rootMenu[index],
        ),
        floatingActionButton: const FAB(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
