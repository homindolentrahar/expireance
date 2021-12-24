import 'dart:io';

import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/core/presentation/dialogs.dart';
import 'package:expireance/core/presentation/fields.dart';
import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:expireance/features/expire_items/domain/models/expire_item_model.dart';
import 'package:expireance/features/expire_items/presentation/controllers/category_controller.dart';
import 'package:expireance/features/expire_items/presentation/controllers/expire_controller.dart';
import 'package:expireance/features/expire_items/presentation/controllers/expire_form_controller.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_badges.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_category.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_image.dart';
import 'package:expireance/core/presentation/buttons.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_amount.dart';
import 'package:expireance/features/expire_items/presentation/widgets/expire_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddExpireForm extends StatefulWidget {
  const AddExpireForm({Key? key}) : super(key: key);

  @override
  State<AddExpireForm> createState() => _AddExpireFormState();
}

class _AddExpireFormState extends State<AddExpireForm> {
  late GlobalKey<FormBuilderState> _formKey;
  late ExpireController _controller;

  @override
  void initState() {
    _formKey = GlobalKey<FormBuilderState>();
    _controller = Get.find<ExpireController>();

    super.initState();
  }

  Future<void> handleSave(BuildContext context) async {
    final cubit = context.read<ExpireFormCubit>();
    //Run validation
    if (context.read<ExpireFormCubit>().state.expireDate.isEmpty) {
      cubit.addErrors(ExpireFormError.expireDate, "Expire date required");
    }
    if (context.read<ExpireFormCubit>().state.category == null) {
      cubit.addErrors(ExpireFormError.category, "Category required");
    }

    cubit.runValidation();
    cubit.validate();

    if (_formKey.currentState!.saveAndValidate() &&
        context.read<ExpireFormCubit>().state.formValid) {
      //  Do store expire item
      final state = context.read<ExpireFormCubit>().state;

      final model = ExpireItemModel(
        id: const Uuid().v4(),
        name: state.name,
        desc: state.desc,
        amount: state.amount,
        date: DateTime.parse(state.expireDate),
        image: state.image,
        category: state.category ?? CategoryModel.empty(),
      );

      await _controller.storeExpireItem(model);

      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExpireFormCubit>(
      create: (ctx) => ExpireFormCubit(),
      child: BlocBuilder<ExpireFormCubit, ExpireFormState>(
        builder: (formCtx, state) => FormBuilder(
          key: _formKey,
          autovalidateMode: state.runValidation
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          autoFocusOnValidationFailure: true,
          child: ListView(
            padding: const EdgeInsets.all(24),
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const PlainBackButton(),
                  const SizedBox(width: 8),
                  Text(
                    "Add Expire Item",
                    style: Get.textTheme.headline6,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          ExpireImage(
                            imageFile:
                                state.image.isEmpty ? null : File(state.image),
                            removeImage: () {
                              formCtx.read<ExpireFormCubit>().clearImage();

                              Get.back();
                            },
                            pickImage: () {
                              formCtx
                                  .read<ExpireFormCubit>()
                                  .setImage(ImageSource.gallery);

                              Get.back();
                            },
                            capturePhoto: () {
                              formCtx
                                  .read<ExpireFormCubit>()
                                  .setImage(ImageSource.camera);

                              Get.back();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OutlinedField(
                              name: "name",
                              placeholder: "Name your item",
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
                                  formCtx
                                      .read<ExpireFormCubit>()
                                      .nameChanged(value);
                                }
                              },
                            ),
                            const SizedBox(height: 8),
                            ExpireAmount(
                              value: state.amount,
                              increase: () {
                                formCtx
                                    .read<ExpireFormCubit>()
                                    .amountChanged(state.amount + 1);
                              },
                              decrease: () {
                                formCtx
                                    .read<ExpireFormCubit>()
                                    .amountChanged(state.amount - 1);
                              },
                              incrementalChange: (value) {
                                formCtx
                                    .read<ExpireFormCubit>()
                                    .amountChanged(state.amount + value);
                              },
                            ),
                            const SizedBox(height: 16),
                            BlocBuilder<CategoryCubit, List<CategoryModel>>(
                              builder: (categoryCtx, categories) =>
                                  ExpireCategorySelector(
                                value: state.category,
                                models: categories,
                                selectCategory: (model) {
                                  formCtx
                                      .read<ExpireFormCubit>()
                                      .removeErrors(ExpireFormError.category);
                                  formCtx
                                      .read<ExpireFormCubit>()
                                      .categoryChanged(model);

                                  Get.back();
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
                                : const SizedBox.shrink()
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  UnderlinedField(
                    name: "desc",
                    placeholder: "Describe your item",
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
                        formCtx.read<ExpireFormCubit>().descChanged(value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpireDate(
                        date: state.expireDate.isEmpty
                            ? null
                            : DateTime.parse(state.expireDate),
                        pickDate: (pickedDate) {
                          formCtx
                              .read<ExpireFormCubit>()
                              .removeErrors(ExpireFormError.expireDate);
                          formCtx
                              .read<ExpireFormCubit>()
                              .expireChanged(pickedDate);
                        },
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
                ],
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
  late ExpireController _controller;

  @override
  void initState() {
    _formKey = GlobalKey<FormBuilderState>();
    _controller = Get.find<ExpireController>()
      ..fetchSingleExpireItem(widget.id);

    super.initState();
  }

  Future<void> handleSave(BuildContext context) async {
    final cubit = context.read<ExpireFormCubit>();
    //Run validation
    if (context.read<ExpireFormCubit>().state.expireDate.isEmpty) {
      cubit.addErrors(ExpireFormError.expireDate, "Expired date required");
    }
    if (context.read<ExpireFormCubit>().state.category == null) {
      cubit.addErrors(ExpireFormError.expireDate, "Category required");
    }

    cubit.runValidation();
    cubit.validate();

    if (_formKey.currentState!.saveAndValidate() &&
        context.read<ExpireFormCubit>().state.formValid) {
      final state = context.read<ExpireFormCubit>().state;
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

      await _controller.updateExpireItem(widget.id, model);

      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExpireFormCubit>(
      create: (ctx) =>
          ExpireFormCubit()..populateInitialData(_controller.singleExpireItem!),
      child: BlocBuilder<ExpireFormCubit, ExpireFormState>(
        builder: (formCtx, state) {
          return FormBuilder(
            key: _formKey,
            autovalidateMode: state.runValidation
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            autoFocusOnValidationFailure: true,
            child: ListView(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const PlainBackButton(),
                        const SizedBox(width: 8),
                        Text(
                          "Update Expire Item",
                          style: Get.textTheme.headline6,
                        ),
                      ],
                    ),
                    DeleteButton(
                      onPressed: () {
                        Get.dialog(
                          DangerConfirmationDialog(
                            title: "Delete ${state.name}?",
                            message:
                                "You cannot recover this items once it's deleted",
                            onPositive: () {
                              _controller.deleteExpireItem(widget.id);

                              Get.back(); // Cancel dialog
                              Get.back(); // Close sheet
                            },
                            onNegative: () {
                              Get.back();
                            },
                          ),
                        );
                      },
                    ),
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
                            formCtx.read<ExpireFormCubit>().clearImage();

                            Get.back();
                          },
                          pickImage: () {
                            formCtx
                                .read<ExpireFormCubit>()
                                .setImage(ImageSource.gallery);

                            Get.back();
                          },
                          capturePhoto: () {
                            formCtx
                                .read<ExpireFormCubit>()
                                .setImage(ImageSource.camera);

                            Get.back();
                          },
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              OutlinedField(
                                name: "name",
                                initialValue: state.name,
                                placeholder: "Name your item",
                                validators: [
                                  FormBuilderValidators.required(context),
                                  FormBuilderValidators.minLength(
                                    context,
                                    3,
                                    errorText:
                                        "Must have at least 3 characters",
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    formCtx
                                        .read<ExpireFormCubit>()
                                        .nameChanged(value);
                                  }
                                },
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(right: 48),
                                child: ExpireAmount(
                                  value: state.amount,
                                  increase: () {
                                    formCtx
                                        .read<ExpireFormCubit>()
                                        .amountChanged(state.amount + 1);
                                  },
                                  decrease: () {
                                    formCtx
                                        .read<ExpireFormCubit>()
                                        .amountChanged(state.amount - 1);
                                  },
                                  incrementalChange: (value) {
                                    formCtx
                                        .read<ExpireFormCubit>()
                                        .amountChanged(
                                          state.amount + value,
                                        );
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              BlocBuilder<CategoryCubit, List<CategoryModel>>(
                                bloc: formCtx.watch<CategoryCubit>(),
                                builder: (categoryCtx, categories) =>
                                    ExpireCategorySelector(
                                  value: state.category,
                                  models: categories,
                                  selectCategory: (model) {
                                    formCtx
                                        .read<ExpireFormCubit>()
                                        .removeErrors(ExpireFormError.category);
                                    formCtx
                                        .read<ExpireFormCubit>()
                                        .categoryChanged(model);

                                    Get.back();
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
                    UnderlinedField(
                      name: "desc",
                      initialValue: state.desc,
                      placeholder: "Describe your item",
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
                          formCtx.read<ExpireFormCubit>().descChanged(value);
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
                                    .read<ExpireFormCubit>()
                                    .expireChanged(pickedDate);
                              },
                            ),
                            const SizedBox(width: 32),
                            ExpireTimeBadge(
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
