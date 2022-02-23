import 'package:flutter/material.dart';
import 'package:expireance/common/theme/app_color.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:auto_route/auto_route.dart';

class FilledField extends StatelessWidget {
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

  const FilledField({
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
        filled: true,
        fillColor: AppColor.light.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
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
          color: AppColor.light,
          borderRadius: BorderRadius.circular(2),
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
                  borderRadius: BorderRadius.circular(2),
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
