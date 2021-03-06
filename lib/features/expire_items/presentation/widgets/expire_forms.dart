import 'dart:io';

import 'package:expireance/common/constants/box_constants.dart';
import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/core/presentation/widgets/dialogs.dart';
import 'package:expireance/core/presentation/widgets/fields.dart';
import 'package:expireance/di/app_module.dart';
import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:expireance/features/expire_items/domain/models/expire_item_model.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:expireance/features/expire_items/presentation/application/category_watcher.dart';
import 'package:expireance/features/expire_items/presentation/application/expire_actor.dart';
import 'package:expireance/features/expire_items/presentation/application/expire_form_controller.dart';
import 'package:expireance/features/expire_items/presentation/application/expire_watcher.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_badge.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_category.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_image.dart';
import 'package:expireance/core/presentation/widgets/buttons.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_amount.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_date.dart';
import 'package:expireance/utils/sheet_dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:auto_route/auto_route.dart';

class AddExpireForm extends StatefulWidget {
  const AddExpireForm({Key? key}) : super(key: key);

  @override
  State<AddExpireForm> createState() => _AddExpireFormState();
}

class _AddExpireFormState extends State<AddExpireForm> {
  late GlobalKey<FormBuilderState> _formKey;
  late Box<String> _lostDataBox;

  @override
  void initState() {
    _formKey = GlobalKey<FormBuilderState>();
    _lostDataBox = injector.get<Box<String>>(
      instanceName: BoxConstants.lostDataBox,
    );

    super.initState();
  }

  Future<void> handleSave(BuildContext context) async {
    final controller = context.read<ExpireFormController>();
    //Run validation
    if (context.read<ExpireFormController>().state.expireDate.isEmpty) {
      controller.addErrors(ExpireFormError.expireDate, "Expire date required");
    }
    if (context.read<ExpireFormController>().state.category == null) {
      controller.addErrors(ExpireFormError.category, "Category required");
    }

    controller.runValidation();
    controller.validate();

    if (_formKey.currentState!.saveAndValidate() &&
        context.read<ExpireFormController>().state.formValid) {
      //  Do store expire item
      final state = context.read<ExpireFormController>().state;

      final model = ExpireItemModel(
        id: const Uuid().v4(),
        name: state.name,
        desc: state.desc,
        amount: state.amount,
        date: DateTime.parse(state.expireDate),
        image: state.image,
        category: state.category ?? CategoryModel.empty(),
      );

      await context.read<ExpireActor>().storeExpireItem(model);

      context.router.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExpireFormController>(
      create: (ctx) => ExpireFormController(),
      child: BlocBuilder<ExpireFormController, ExpireFormState>(
        builder: (formCtx, state) {
          if (_lostDataBox.isNotEmpty) {
            formCtx
                .read<ExpireFormController>()
                .imageChanged(_lostDataBox.getAt(0));
          }

          return FormBuilder(
            key: _formKey,
            autovalidateMode: state.runValidation
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            autoFocusOnValidationFailure: true,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Add Expire Item",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpireImage(
                      imageFile: state.image.isEmpty ? null : File(state.image),
                      removeImage: () {
                        formCtx.read<ExpireFormController>().clearImage();

                        context.router.pop();
                      },
                      pickImage: () {
                        formCtx
                            .read<ExpireFormController>()
                            .setImage(ImageSource.gallery);

                        context.router.pop();
                      },
                      capturePhoto: () {
                        formCtx
                            .read<ExpireFormController>()
                            .setImage(ImageSource.camera);

                        context.router.pop();
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField.filled(
                            name: "name",
                            placeholder: "Name your item",
                            validators: [
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(
                                3,
                                errorText: "Must have at least 3 characters",
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                formCtx
                                    .read<ExpireFormController>()
                                    .nameChanged(value);
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          ExpireAmount(
                            value: state.amount,
                            increase: () {
                              formCtx
                                  .read<ExpireFormController>()
                                  .amountChanged(state.amount + 1);
                            },
                            decrease: () {
                              formCtx
                                  .read<ExpireFormController>()
                                  .amountChanged(state.amount - 1);
                            },
                            incrementalChange: (value) {
                              formCtx
                                  .read<ExpireFormController>()
                                  .amountChanged(state.amount + value);
                            },
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<CategoryWatcher, List<CategoryModel>>(
                            bloc: formCtx.read<CategoryWatcher>()
                              ..listenCategories(),
                            builder: (categoryCtx, categories) =>
                                ExpireCategorySelector(
                              value: state.category,
                              models: categories,
                              selectCategory: (model) {
                                formCtx
                                    .read<ExpireFormController>()
                                    .removeErrors(ExpireFormError.category);
                                formCtx
                                    .read<ExpireFormController>()
                                    .categoryChanged(model);

                                context.router.pop();
                              },
                            ),
                          ),
                          state.runValidation &&
                                  state.categoryErrorMsg.isNotEmpty
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      state.categoryErrorMsg,
                                      style: const TextStyle(
                                        color: AppColor.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  ],
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppTextField.underlined(
                  name: "desc",
                  placeholder: "Describe your item",
                  validators: [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(
                      3,
                      errorText: "Must have at least 3 characters",
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      formCtx.read<ExpireFormController>().descChanged(value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ExpireDate(
                          date: state.expireDate.isEmpty
                              ? null
                              : DateTime.parse(state.expireDate),
                          pickDate: (pickedDate) {
                            formCtx
                                .read<ExpireFormController>()
                                .removeErrors(ExpireFormError.expireDate);
                            formCtx
                                .read<ExpireFormController>()
                                .expireChanged(pickedDate);
                          },
                        ),
                        state.expireDate.isEmpty
                            ? const SizedBox.shrink()
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 32),
                                  ExpireBadge(
                                    expiredDate:
                                        DateTime.parse(state.expireDate),
                                  ),
                                ],
                              ),
                      ],
                    ),
                    state.runValidation && state.expireDateErrorMsg.isNotEmpty
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                state.expireDateErrorMsg,
                                style: const TextStyle(
                                  color: AppColor.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            ],
                          )
                        : const SizedBox.shrink()
                  ],
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  title: "Save",
                  onPressed: () => handleSave(formCtx),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class UpdateExpireForm extends StatefulWidget {
  final String id;

  const UpdateExpireForm({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<UpdateExpireForm> createState() => _UpdateExpireFormState();
}

class _UpdateExpireFormState extends State<UpdateExpireForm> {
  late GlobalKey<FormBuilderState> _formKey;
  late SingleExpireWatcher _singleWatcher;
  late Box<String> _lostDataBox;

  @override
  void initState() {
    _formKey = GlobalKey<FormBuilderState>();
    _singleWatcher = SingleExpireWatcher(
      injector.get<IExpireRepository>(),
      id: widget.id,
    );
    _lostDataBox = injector.get<Box<String>>(
      instanceName: BoxConstants.lostDataBox,
    );

    super.initState();
  }

  Future<void> handleSave(BuildContext context) async {
    final controller = context.read<ExpireFormController>();
    //Run validation
    if (context.read<ExpireFormController>().state.expireDate.isEmpty) {
      controller.addErrors(ExpireFormError.expireDate, "Expired date required");
    }
    if (context.read<ExpireFormController>().state.category == null) {
      controller.addErrors(ExpireFormError.expireDate, "Category required");
    }

    controller.runValidation();
    controller.validate();

    if (_formKey.currentState!.saveAndValidate() &&
        context.read<ExpireFormController>().state.formValid) {
      final state = context.read<ExpireFormController>().state;
      //  Do store expire item
      final model = ExpireItemModel(
        id: widget.id,
        name: state.name,
        desc: state.desc,
        amount: state.amount,
        date: DateTime.parse(state.expireDate),
        image: state.image,
        category: state.category ?? CategoryModel.empty(),
      );

      await context.read<ExpireActor>().updateExpireItem(widget.id, model);

      context.router.pop();
    }
  }

  bool isFormNotChanged(ExpireFormState state, ExpireItemModel model) {
    return state.image == model.image &&
        state.name == model.name &&
        state.amount == model.amount &&
        state.category!.id == model.category.id &&
        state.desc == model.desc &&
        state.expireDate == model.date.toIso8601String();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExpireFormController>(
      create: (ctx) =>
          ExpireFormController()..populateInitialData(_singleWatcher.state!),
      child: BlocBuilder<ExpireFormController, ExpireFormState>(
        builder: (formCtx, state) {
          if (_lostDataBox.isNotEmpty) {
            formCtx
                .read<ExpireFormController>()
                .imageChanged(_lostDataBox.getAt(0));
          }

          return FormBuilder(
            key: _formKey,
            autovalidateMode: state.runValidation
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            autoFocusOnValidationFailure: true,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Update Expire Item",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    DeleteButton(
                      onPressed: () {
                        SheetDialogUtils.showAppDialog(
                          context: context,
                          child: DangerConfirmationDialog(
                            title: "Delete ${state.name}?",
                            message:
                                "You cannot recover this items once it's deleted",
                            onPositive: () {
                              formCtx
                                  .read<ExpireActor>()
                                  .deleteExpireItem(widget.id);

                              final currentRoute = context.router.current;
                              context.router
                                  .popUntilRouteWithName(currentRoute.name);
                            },
                            onNegative: () {
                              context.router.pop();
                            },
                          ),
                        );
                      },
                    )
                  ],
                ),
                const SizedBox(height: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExpireImage(
                          imageFile:
                              state.image.isEmpty ? null : File(state.image),
                          removeImage: () {
                            formCtx.read<ExpireFormController>().clearImage();

                            context.router.pop();
                          },
                          pickImage: () {
                            formCtx
                                .read<ExpireFormController>()
                                .setImage(ImageSource.gallery);

                            context.router.pop();
                          },
                          capturePhoto: () {
                            formCtx
                                .read<ExpireFormController>()
                                .setImage(ImageSource.camera);

                            context.router.pop();
                          },
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextField.filled(
                                name: "name",
                                initialValue: state.name,
                                placeholder: "Name your item",
                                validators: [
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.minLength(
                                    3,
                                    errorText:
                                        "Must have at least 3 characters",
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    formCtx
                                        .read<ExpireFormController>()
                                        .nameChanged(value);
                                  }
                                },
                              ),
                              const SizedBox(height: 8),
                              ExpireAmount(
                                value: state.amount,
                                increase: () {
                                  formCtx
                                      .read<ExpireFormController>()
                                      .amountChanged(state.amount + 1);
                                },
                                decrease: () {
                                  formCtx
                                      .read<ExpireFormController>()
                                      .amountChanged(state.amount - 1);
                                },
                                incrementalChange: (value) {
                                  formCtx
                                      .read<ExpireFormController>()
                                      .amountChanged(
                                        state.amount + value,
                                      );
                                },
                              ),
                              const SizedBox(height: 16),
                              BlocBuilder<CategoryWatcher, List<CategoryModel>>(
                                bloc: formCtx.read<CategoryWatcher>()
                                  ..listenCategories(),
                                builder: (categoryCtx, categories) =>
                                    ExpireCategorySelector(
                                  value: state.category,
                                  models: categories,
                                  selectCategory: (model) {
                                    formCtx
                                        .read<ExpireFormController>()
                                        .removeErrors(ExpireFormError.category);
                                    formCtx
                                        .read<ExpireFormController>()
                                        .categoryChanged(model);

                                    context.router.pop();
                                  },
                                ),
                              ),
                              state.runValidation &&
                                      state.categoryErrorMsg.isNotEmpty
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(
                                          state.categoryErrorMsg,
                                          style: const TextStyle(
                                            color: AppColor.red,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        )
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppTextField.underlined(
                      name: "desc",
                      initialValue: state.desc,
                      placeholder: "Describe your item",
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(
                          3,
                          errorText: "Must have at least 3 characters",
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          formCtx
                              .read<ExpireFormController>()
                              .descChanged(value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ExpireDate(
                              date: state.expireDate.isEmpty
                                  ? null
                                  : DateTime.parse(state.expireDate),
                              pickDate: (pickedDate) {
                                formCtx
                                    .read<ExpireFormController>()
                                    .expireChanged(pickedDate);
                              },
                            ),
                            const SizedBox(width: 32),
                            ExpireBadge(
                              expiredDate: DateTime.parse(state.expireDate),
                            ),
                          ],
                        ),
                        state.runValidation &&
                                state.expireDateErrorMsg.isNotEmpty
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    state.expireDateErrorMsg,
                                    style: const TextStyle(
                                      color: AppColor.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                ],
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  title: "Save",
                  onPressed: isFormNotChanged(state, _singleWatcher.state!)
                      ? null
                      : () => handleSave(formCtx),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
