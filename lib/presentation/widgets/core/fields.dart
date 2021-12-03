import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:expireance/common/theme/app_color.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class OutlinedField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String name;
  final String placeholder;
  final TextAlign textAlign;
  final TextInputAction action;
  final TextInputType type;
  final bool obscure;
  final ValueChanged<String?> onChanged;
  final List<String? Function(String?)> validators;

  const OutlinedField({
    Key? key,
    this.controller,
    this.initialValue,
    required this.name,
    required this.placeholder,
    this.textAlign = TextAlign.start,
    this.action = TextInputAction.done,
    this.type = TextInputType.text,
    this.obscure = false,
    required this.onChanged,
    required this.validators,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      controller: controller,
      initialValue: initialValue,
      name: name,
      textInputAction: action,
      keyboardType: type,
      obscureText: obscure,
      style: const TextStyle(
        color: AppColor.black,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      textAlign: textAlign,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: AppColor.gray, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: AppColor.black, width: 1.3)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: AppColor.red, width: 1.3)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: AppColor.red, width: 1.3)),
        hintText: placeholder,
        hintStyle: const TextStyle(
          color: AppColor.gray,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        errorStyle: const TextStyle(
          color: AppColor.red,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
      cursorColor: AppColor.black,
      cursorRadius: const Radius.circular(2),
      onChanged: onChanged,
      validator: FormBuilderValidators.compose(validators),
    );
  }
}

class UnderlinedField extends StatelessWidget {
  final String? initialValue;
  final String name;
  final String placeholder;
  final TextAlign textAlign;
  final TextInputAction action;
  final TextInputType type;
  final bool obscure;
  final ValueChanged<String?> onChanged;
  final List<String? Function(String?)> validators;

  const UnderlinedField({
    Key? key,
    this.initialValue,
    required this.name,
    required this.placeholder,
    this.textAlign = TextAlign.start,
    this.action = TextInputAction.done,
    this.type = TextInputType.text,
    this.obscure = false,
    required this.onChanged,
    required this.validators,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      initialValue: initialValue,
      name: name,
      textAlign: textAlign,
      textInputAction: action,
      keyboardType: type,
      obscureText: obscure,
      style: const TextStyle(
        color: AppColor.black,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: AppColor.gray, width: 1)),
        focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: AppColor.black, width: 1.3)),
        errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: AppColor.red, width: 1.3)),
        focusedErrorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: AppColor.red, width: 1.3)),
        hintText: placeholder,
        hintStyle: const TextStyle(
          color: AppColor.gray,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        errorStyle: const TextStyle(
          color: AppColor.red,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
      cursorColor: AppColor.black,
      cursorRadius: const Radius.circular(2),
      onChanged: onChanged,
      validator: FormBuilderValidators.compose(validators),
    );
  }
}
