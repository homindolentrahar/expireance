import 'package:expireance/di/app_module.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:expireance/features/expire_items/presentation/application/expire_watcher.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PriorityExpireScreen extends StatelessWidget {
  static const route = "/expired-list";

  const PriorityExpireScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PriorityExpireWatcher>(
      create: (ctx) => PriorityExpireWatcher(injector.get<IExpireRepository>()),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Get.theme.canvasColor,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: SvgPicture.asset(
                "assets/icons/back.svg",
                width: 24,
                height: 24,
                color: Get.theme.primaryColor,
              ),
            ),
            title: Text(
              "Expire items in a week",
              style: Get.textTheme.headline6,
            ),
          ),
          body: Builder(builder: (bodyCtx) {
            return BlocBuilder<PriorityExpireWatcher, ExpireWatcherState>(
              bloc: bodyCtx.read<PriorityExpireWatcher>()
                ..listenPriorityExpireItems(),
              builder: (ctx, state) => ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: state.items.length,
                itemBuilder: (ctx, index) {
                  final model = state.items[index];

                  return ExpireItemList(model: model);
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
