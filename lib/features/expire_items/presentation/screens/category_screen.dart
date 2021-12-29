import 'package:expireance/core/presentation/widgets/buttons.dart';
import 'package:expireance/core/presentation/widgets/drawers.dart';
import 'package:expireance/core/presentation/widgets/sheets.dart';
import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:expireance/features/expire_items/presentation/application/category_watcher.dart';
import 'package:expireance/features/expire_items/presentation/widgets/category_forms.dart';
import 'package:expireance/features/expire_items/presentation/widgets/category_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
                showBarModalBottomSheet(
                  context: context,
                  builder: (ctx) => Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: const AddCategoryForm(),
                  ),
                  expand: false,
                  bounce: true,
                  topControl: const SheetIndicator(),
                  backgroundColor: Theme.of(context).canvasColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4)),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<CategoryWatcher, List<CategoryModel>>(
          bloc: context.read<CategoryWatcher>()..listenCategories(),
          builder: (builderCtx, categories) => ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (ctx, index) => CategoryItemList(
              model: categories[index],
            ),
          ),
        ),
      ),
    );
  }
}
