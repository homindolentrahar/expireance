import 'dart:developer';
import 'dart:io';

import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/domain/models/expire_category_model.dart';
import 'package:expireance/domain/models/expire_item_model.dart';
import 'package:expireance/presentation/controller/expire_controller.dart';
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
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class AddExpireForm extends StatefulWidget {
  const AddExpireForm({Key? key}) : super(key: key);

  @override
  State<AddExpireForm> createState() => _AddExpireFormState();
}

class _AddExpireFormState extends State<AddExpireForm> {
  late GlobalKey<FormBuilderState> _formKey;
  late ExpireController _controller;
  late TextEditingController _amountController;
  late ImagePicker _imagePicker;

  //  Variable for form validation
  bool _runValidation = false;

  //  Mutable values
  DateTime? _expiredDate;
  ExpireCategoryModel? _expireCategory;
  File? _image;

  //  Error for mutable values
  String _imageErrorMsg = "";
  String _categoryErrorMsg = "";
  String _dateErrorMsg = "";

  @override
  void initState() {
    _formKey = GlobalKey<FormBuilderState>();
    _controller = Get.find<ExpireController>()..fetchCategories();
    _amountController = TextEditingController(text: "1");
    _imagePicker = Get.find<ImagePicker>();

    super.initState();
  }

  Future<void> handleSave() async {
    //Run validation
    setState(() {
      if (_image == null) {
        _imageErrorMsg = "Image required";
      }
      if (_expiredDate == null) {
        _dateErrorMsg = "Expired date required";
      }
      if (_expireCategory == null) {
        _categoryErrorMsg = "Category required";
      }

      _runValidation = true;
    });

    if (_formKey.currentState!.saveAndValidate() &&
        _expiredDate != null &&
        _expireCategory != null &&
        _image != null) {
      log("Form valid!");

      final formData = _formKey.currentState!.value;
      log("Form data: $formData\nDate: $_expiredDate\nImage: ${_image!.path}");

      //  Do store expire item
      final model = ExpireItemModel(
        id: const Uuid().v4(),
        name: formData['name'],
        desc: formData['desc'],
        amount: int.parse(formData['amount']),
        date: _expiredDate!,
        image: _image!.path,
        categoryId: _expireCategory!.id,
      );

      await _controller.storeExpireItem(model);

      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      autovalidateMode:
          _runValidation ? AutovalidateMode.always : AutovalidateMode.disabled,
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
                        imageFile: _image,
                        pickImage: () async {
                          final image = await _imagePicker.pickImage(
                            source: ImageSource.gallery,
                          );

                          if (image == null) return;

                          final path =
                              (await getApplicationDocumentsDirectory()).path;
                          File imageFile = await File(image.path).copy(
                            "$path/${image.name}",
                          );

                          setState(() {
                            _imageErrorMsg = "";

                            _image = imageFile;

                            log("Image data: $_image");
                          });

                          Get.back();
                        },
                        capturePhoto: () async {
                          final image = await _imagePicker.pickImage(
                            source: ImageSource.camera,
                          );

                          if (image == null) return;

                          final path =
                              (await getApplicationDocumentsDirectory()).path;
                          File imageFile = await File(image.path)
                              .copy("$path/${image.name}");

                          setState(() {
                            _imageErrorMsg = "";

                            _image = imageFile;

                            log("Image data: $_image");
                          });

                          Get.back();
                        },
                      ),
                      if (_runValidation) const SizedBox(height: 4),
                      if (_runValidation)
                        Text(
                          _imageErrorMsg,
                          style: const TextStyle(
                            color: AppColor.red,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
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
                          padding: const EdgeInsets.only(right: 32),
                          child: ExpireAmount(
                            amountController: _amountController,
                            increase: () {
                              setState(() {
                                _amountController.text =
                                    (int.parse(_amountController.text) + 1)
                                        .toString();
                              });
                            },
                            decrease: () {
                              if (int.parse(_amountController.text) > 1) {
                                setState(() {
                                  _amountController.text =
                                      (int.parse(_amountController.text) - 1)
                                          .toString();
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        ExpireCategory(
                          value: _expireCategory,
                          models: _controller.expireCategories,
                          selectCategory: (categoryModel) {
                            setState(() {
                              _categoryErrorMsg = "";

                              _expireCategory = categoryModel;
                            });

                            Get.back();
                          },
                        ),
                        if (_runValidation) const SizedBox(height: 4),
                        if (_runValidation)
                          Text(
                            _categoryErrorMsg,
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
                    date: _expiredDate,
                    showDate: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 8),
                      ).then(
                        (pickedDate) {
                          if (pickedDate != null) {
                            setState(() {
                              _dateErrorMsg = "";

                              _expiredDate = pickedDate;
                            });
                          }
                        },
                      );
                    },
                  ),
                  if (_runValidation) const SizedBox(height: 4),
                  if (_runValidation)
                    Text(
                      _dateErrorMsg,
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
            onPressed: handleSave,
          ),
        ],
      ),
    );
  }
}
