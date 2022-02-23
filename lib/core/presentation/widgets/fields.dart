import 'package:flutter/material.dart';
import 'package:expireance/common/theme/app_color.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:auto_route/auto_route.dart';

enum AppTextFieldType {
  filled,
  outlined,
  underlined,
}

class AppTextFieldBorders {
  final InputBorder enabledBorder;
  final InputBorder focusedBorder;
  final InputBorder errorBorder;
  final InputBorder focusedErrorBorder;

  AppTextFieldBorders({
    required this.enabledBorder,
    required this.focusedBorder,
    required this.errorBorder,
    required this.focusedErrorBorder,
  });
}

class AppTextField extends StatelessWidget {
  final AppTextFieldType fieldType;
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

  AppTextField._({
    Key? key,
    required this.fieldType,
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

  factory AppTextField.filled({
    TextEditingController? controller,
    String? initialValue,
    required String name,
    required String placeholder,
    TextAlign textAlign = TextAlign.start,
    TextInputAction action = TextInputAction.done,
    TextInputType type = TextInputType.text,
    bool obscure = false,
    required ValueChanged<String?> onChanged,
    required List<String? Function(String?)> validators,
  }) =>
      AppTextField._(
        fieldType: AppTextFieldType.filled,
        controller: controller,
        initialValue: initialValue,
        name: name,
        placeholder: placeholder,
        textAlign: textAlign,
        action: action,
        type: TextInputType.text,
        obscure: obscure,
        onChanged: onChanged,
        validators: validators,
      );

  factory AppTextField.outlined({
    TextEditingController? controller,
    String? initialValue,
    required String name,
    required String placeholder,
    TextAlign textAlign = TextAlign.start,
    TextInputAction action = TextInputAction.done,
    TextInputType type = TextInputType.text,
    bool obscure = false,
    required ValueChanged<String?> onChanged,
    required List<String? Function(String?)> validators,
  }) =>
      AppTextField._(
        fieldType: AppTextFieldType.outlined,
        controller: controller,
        initialValue: initialValue,
        name: name,
        placeholder: placeholder,
        textAlign: textAlign,
        action: action,
        type: TextInputType.text,
        obscure: obscure,
        onChanged: onChanged,
        validators: validators,
      );

  factory AppTextField.underlined({
    TextEditingController? controller,
    String? initialValue,
    required String name,
    required String placeholder,
    TextAlign textAlign = TextAlign.start,
    TextInputAction action = TextInputAction.done,
    TextInputType type = TextInputType.text,
    bool obscure = false,
    required ValueChanged<String?> onChanged,
    required List<String? Function(String?)> validators,
  }) =>
      AppTextField._(
        fieldType: AppTextFieldType.underlined,
        controller: controller,
        initialValue: initialValue,
        name: name,
        placeholder: placeholder,
        textAlign: textAlign,
        action: action,
        type: TextInputType.text,
        obscure: obscure,
        onChanged: onChanged,
        validators: validators,
      );

  final Map<AppTextFieldType, AppTextFieldBorders> inputBorders = {
    AppTextFieldType.filled: AppTextFieldBorders(
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.transparent)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.black, width: 1.3)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.red, width: 1.3)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.red, width: 1.3)),
    ),
    AppTextFieldType.outlined: AppTextFieldBorders(
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.transparent)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.black, width: 1.3)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.red, width: 1.3)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.red, width: 1.3)),
    ),
    AppTextFieldType.underlined: AppTextFieldBorders(
      enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide:
              BorderSide(color: AppColor.gray.withOpacity(0.25), width: 2)),
      focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: AppColor.black, width: 2)),
      errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: AppColor.red, width: 2)),
      focusedErrorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: AppColor.red, width: 2)),
    ),
  };

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
        filled: fieldType == AppTextFieldType.filled,
        fillColor: fieldType == AppTextFieldType.filled
            ? AppColor.light.withOpacity(0.5)
            : Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: inputBorders[fieldType]?.enabledBorder,
        focusedBorder: inputBorders[fieldType]?.focusedBorder,
        errorBorder: inputBorders[fieldType]?.errorBorder,
        focusedErrorBorder: inputBorders[fieldType]?.focusedErrorBorder,
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
      cursorRadius: const Radius.circular(4),
      onChanged: onChanged,
      validator: FormBuilderValidators.compose(validators),
    );
  }
}

class SearchField extends StatefulWidget {
  final ValueChanged<String?> onChanged;

  const SearchField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late GlobalKey<FormBuilderState> formKey;

  @override
  void initState() {
    formKey = GlobalKey<FormBuilderState>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: AppColor.light.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                context.router.pop();
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(360),
                ),
                child: SvgPicture.asset(
                  "assets/icons/back.svg",
                  width: 20,
                  height: 20,
                  color: Theme.of(context).canvasColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SearchFieldText(onChanged: widget.onChanged),
            ),
            const SizedBox(width: 12),
            SvgPicture.asset(
              "assets/icons/search.svg",
              width: 24,
              height: 24,
              color: AppColor.gray,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchFieldText extends StatelessWidget {
  final ValueChanged<String?> onChanged;

  const _SearchFieldText({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: "search",
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      style: const TextStyle(
        color: AppColor.black,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      decoration: const InputDecoration(
        isDense: true,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        hintText: "Search for items",
        hintStyle: TextStyle(
          color: AppColor.gray,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        errorStyle: TextStyle(
          color: AppColor.red,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
      cursorColor: AppColor.black,
      cursorRadius: const Radius.circular(2),
      onChanged: onChanged,
    );
  }
}
