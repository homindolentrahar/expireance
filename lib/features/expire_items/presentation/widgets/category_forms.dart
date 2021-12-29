import 'package:expireance/core/presentation/widgets/buttons.dart';
import 'package:expireance/core/presentation/widgets/fields.dart';
import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:expireance/features/expire_items/presentation/application/category_actor.dart';
import 'package:expireance/features/expire_items/presentation/application/category_form_controller.dart';
import 'package:expireance/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:uuid/uuid.dart';
import 'package:auto_route/auto_route.dart';

class AddCategoryForm extends StatefulWidget {
  const AddCategoryForm({Key? key}) : super(key: key);

  @override
  _AddCategoryFormState createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  late GlobalKey<FormBuilderState> _formKey;

  @override
  void initState() {
    _formKey = GlobalKey<FormBuilderState>();

    super.initState();
  }

  Future<void> handleSave(BuildContext context) async {
    final controller = context.read<CategoryFormController>();
    //  Run validation
    controller.runValidation();

    if (_formKey.currentState!.saveAndValidate()) {
      final state = context.read<CategoryFormController>().state;

      final model = CategoryModel(
        id: "category_${const Uuid().v4()}",
        slug: AppUtils.createSlug(state.name),
        name: state.name,
      );

      await context.read<CategoryActor>().addCategory(model);

      context.router.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryFormController>(
      create: (ctx) => CategoryFormController(),
      child: BlocBuilder<CategoryFormController, CategoryFormState>(
        builder: (formCtx, state) => FormBuilder(
          key: _formKey,
          autovalidateMode: state.runValidation
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          autoFocusOnValidationFailure: true,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Add Category",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                const SizedBox(height: 32),
                OutlinedField(
                  name: "name",
                  placeholder: "Category name",
                  validators: [
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.minLength(
                      context,
                      3,
                      errorText: "Must have at least 3 characters",
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      formCtx.read<CategoryFormController>().nameChanged(value);
                    }
                  },
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  title: "Save",
                  onPressed: () => handleSave(formCtx),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
