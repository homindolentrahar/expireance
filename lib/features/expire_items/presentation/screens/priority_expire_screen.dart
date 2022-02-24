import 'package:expireance/core/presentation/widgets/flashbar.dart';
import 'package:expireance/di/app_module.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:expireance/features/expire_items/presentation/application/expire_actor.dart';
import 'package:expireance/features/expire_items/presentation/application/expire_watcher.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_forms.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_items.dart';
import 'package:expireance/utils/sheet_dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_route/auto_route.dart';

class PriorityExpireScreen extends StatelessWidget {
  static const route = "/priority";

  const PriorityExpireScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PriorityExpireWatcher>(
      create: (ctx) => PriorityExpireWatcher(injector.get<IExpireRepository>()),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Theme.of(context).canvasColor,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                context.router.pop();
              },
              icon: SvgPicture.asset(
                "assets/icons/back.svg",
                width: 24,
                height: 24,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(
              "Expire items in a week",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<ExpireActor, ExpireActorState>(
                listener: (ctx, state) {
                  state.maybeWhen(
                    success: (message) => Flashbar(
                      context: context,
                      title: "Yeay!",
                      content: message,
                      type: FlashbarType.SUCCESS,
                    ).flash(),
                    error: (message) => Flashbar(
                      context: context,
                      title: "Something happened!",
                      content: message,
                      type: FlashbarType.ERROR,
                    ).flash(),
                    orElse: () {},
                  );
                },
              ),
            ],
            child: Builder(builder: (bodyCtx) {
              return BlocBuilder<PriorityExpireWatcher, ExpireWatcherState>(
                bloc: bodyCtx.read<PriorityExpireWatcher>()
                  ..listenPriorityExpireItems(),
                builder: (ctx, state) => ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  itemBuilder: (ctx, index) {
                    final model = state.items[index];

                    return ExpireItemList(
                      model: model,
                      onPressed: () {
                        SheetDialogUtils.showAppBarSheet(
                          context: context,
                          child: UpdateExpireForm(id: model.id),
                        );
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
