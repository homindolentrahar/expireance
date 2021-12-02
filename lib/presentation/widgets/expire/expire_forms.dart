import 'dart:io';

import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/domain/models/expire_item_model.dart';
import 'package:expireance/presentation/controller/expire/expire_controller.dart';
import 'package:expireance/presentation/controller/expire/expire_form_controller.dart';
import 'package:expireance/presentation/widgets/core/buttons.dart';
import 'package:expireance/presentation/widgets/core/fields.dart';
import 'package:expireance/presentation/widgets/expire/expire_amount.dart';
import 'package:expireance/presentation/widgets/expire/expire_category.dart';
import 'package:expireance/presentation/widgets/expire/expire_date.dart';
import 'package:expireance/presentation/widgets/expire/expire_image.dart';
import 'package:flutter/material.dart';
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
    _controller = Get.find<ExpireController>()..fetchCategories();

    super.initState();
  }

  Future<void> handleSave(ExpireFormController formCtl) async {
    //Run validation
    if (!formCtl.expiredDateValid) {
      formCtl.errorMessages.putIfAbsent("date", () => "Expired date required");
    }
    if (!formCtl.categoryValid) {
      formCtl.errorMessages.putIfAbsent("category", () => "Category required");
    }

    formCtl.setRunValidation(true);

    if (_formKey.currentState!.saveAndValidate() &&
        formCtl.expiredDateValid &&
        formCtl.categoryValid) {
      final formData = _formKey.currentState!.value;
      //  Do store expire item
      final model = ExpireItemModel(
        id: const Uuid().v4(),
        name: formData['name'],
        desc: formData['desc'],
        amount: formCtl.amountObs,
        date: DateTime.parse(formCtl.expiredDateObs),
        image: formCtl.imageObs,
        categoryId: formCtl.categoryObs,
      );

      await _controller.storeExpireItem(model);

      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<ExpireFormController>(
      init: ExpireFormController(),
      builder: (ctl) => FormBuilder(
        key: _formKey,
        autovalidateMode: ctl.runValidation
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
                              ctl.imageObs.isEmpty ? null : File(ctl.imageObs),
                          removeImage: () {
                            ctl.clearImage();

                            Get.back();
                          },
                          pickImage: () async {
                            await ctl.setImage(ImageSource.gallery);

                            Get.back();
                          },
                          capturePhoto: () async {
                            await ctl.setImage(ImageSource.camera);

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
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(right: 48),
                            child: ExpireAmount(
                              value: ctl.amountObs,
                              increase: () {
                                ctl.setAmount(ctl.amountObs + 1);
                              },
                              decrease: () {
                                ctl.setAmount(ctl.amountObs - 1);
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          ExpireCategory(
                            valueId: ctl.categoryObs,
                            models: _controller.expireCategories,
                            selectCategory: (model) {
                              ctl.errorMessages.remove("category");
                              ctl.setCategory(model.id);

                              Get.back();
                            },
                          ),
                          if (ctl.runValidation) const SizedBox(height: 4),
                          if (ctl.runValidation)
                            Text(
                              ctl.errorMessages["category"] ?? "",
                              style: const TextStyle(
                                color: AppColor.red,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
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
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpireDate(
                      date: ctl.expiredDateObs.isEmpty
                          ? null
                          : DateTime.parse(ctl.expiredDateObs),
                      showDate: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 8),
                        ).then(
                          (pickedDate) {
                            if (pickedDate != null) {
                              ctl.errorMessages.remove("date");
                              ctl.setExpiredDate(pickedDate);
                            }
                          },
                        );
                      },
                    ),
                    if (ctl.runValidation) const SizedBox(height: 4),
                    if (ctl.runValidation)
                      Text(
                        ctl.errorMessages["date"] ?? "",
                        style: const TextStyle(
                          color: AppColor.red,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              title: "Save",
              onPressed: () => handleSave(ctl),
            ),
          ],
        ),
      ),
    );
  }
}
