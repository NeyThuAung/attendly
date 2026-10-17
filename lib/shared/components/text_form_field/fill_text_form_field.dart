import 'package:flutter/material.dart';

import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';

class FillTextFormField extends StatelessWidget {
  final String? hintText;
  final String? fillText;
  final String? initialValue;
  final bool? readOnly;
  final bool? filled;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Icon? suffixIcon;
  final IconButton? suffixIconButton;
  final bool? obscureText;
  final int? maxLine;
  final int? maxLength;
  final void Function()? onTap;
  final Color? fillColor;
  final TextInputType? textInputType;
  final void Function(String)? onChange;
  final bool? isValidate;
  final bool? isVal;
  final String? Function(String?)? validator;
  final String? label;

  const FillTextFormField({
    super.key,
    this.hintText,
    this.fillText,
    this.initialValue,
    this.readOnly,
    this.filled = true,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconButton,
    this.maxLine,
    this.maxLength,
    this.onTap,
    this.obscureText,
    this.fillColor,
    this.textInputType,
    this.onChange,
    this.isValidate,
    this.isVal,
    this.validator,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: context.textTheme.bodyMedium,
      keyboardType: textInputType ?? TextInputType.text,
      onChanged: onChange,
      initialValue: initialValue,
      obscureText: obscureText ?? false,
      onTap: onTap,
      controller: controller,
      maxLines: maxLine ?? 1,
      maxLength: maxLength,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        filled: filled,
        fillColor: fillColor ?? Color(0xffdbdade),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(width: 0, style: BorderStyle.none),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 18.0,
          horizontal: 12,
        ),
        hintText: hintText,
        hintStyle: context.textTheme.bodyMedium?.hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIconButton ?? suffixIcon,
      ),
      validator: validator,
    );
  }
}
