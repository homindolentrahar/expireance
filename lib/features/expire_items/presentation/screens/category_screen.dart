import 'package:expireance/core/presentation/widgets/buttons.dart';
import 'package:expireance/core/presentation/widgets/drawers.dart';
import 'package:expireance/core/presentation/widgets/flashbar.dart';
import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:expireance/features/expire_items/presentation/application/category_actor.dart';
import 'package:expireance/features/expire_items/presentation/application/category_watcher.dart';
import 'package:expireance/features/expire_items/presentation/widgets/category_forms.dart';
import 'package:expireance/features/expire_items/presentation/widgets/category_items.dart';
import 'package:expireance/utils/sheet_dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatelessWidget {
  static const route = "/category";

  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: const RootDrawer(),
        appBar: AppBar(
          leading: const IconHamburgerButton(),
          title: const Text("Categories"),
          centerTitle: true,
          titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
          actions: [
            IconAddButton(
              onPressed: () {
                SheetDialogUtils.showAppBarSheet(
                  context: context,
                  child: const AddCategoryForm(),
                );
              },
            ),
          ],
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<CategoryActor, CategoryActorState>(
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
          child: BlocBuilder<CategoryWatcher, List<CategoryModel>>(
            bloc: context.read<CategoryWatcher>()..listenCategories(),
            builder: (builderCtx, categories) => ListView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (ctx, index) => CategoryItemList(
                onTap: () {
                  SheetDialogUtils.showAppBarSheet(
                    context: context,
                    child: UpdateCategoryForm(id: categories[index].id),
                  );
                },
                model: categories[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
