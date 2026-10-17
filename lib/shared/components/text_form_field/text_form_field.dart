import 'package:flutter/material.dart';

import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';

class AppTextFormField extends StatelessWidget {
  final bool autocorrect;
  final bool autofocus;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? hintText;
  final bool enabled;
  final Color? fillColor;
  final TextEditingController? controller;
  final EdgeInsets? contentPadding;
  final String? Function(String? value)? validator;
  final void Function(String)? onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? maxLength;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final bool obscureText;
  final AutovalidateMode? autoValidateMode;

  const AppTextFormField({
    super.key,
    this.autocorrect = false,
    this.autofocus = false,
    this.controller,
    this.suffixIcon,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.maxLines,
    this.maxLength,
    this.fillColor,
    this.onFieldSubmitted,
    this.focusNode,
    this.prefixIcon,
    this.onChanged,
    this.contentPadding,
    this.enabled = true,
    this.obscureText = false,
    this.autoValidateMode,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular($styles.insets.xs + 2);
    final effectiveContentPadding =
        contentPadding ??
        EdgeInsets.symmetric(horizontal: $styles.insets.xs, vertical: 16.0);

    // final hasValidator = validator != null;

    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: context.theme.textTheme.bodySmall!.color!.addOpacity(0.2),
      ),
      borderRadius: borderRadius,
    );

    // final decoBottomPadding =
    //     hasValidator ? 0.1 : 0.0;

    final errorBorder = OutlineInputBorder(
      borderSide: BorderSide(color: $styles.color.clrRed),
      borderRadius: borderRadius,
    );

    final focusErrorBorder = OutlineInputBorder(
      borderSide: BorderSide(color: context.theme.primaryColor),
      borderRadius: borderRadius,
    );

    final enableBorder = border;
    final focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(color: context.theme.primaryColor),
      borderRadius: borderRadius,
    );
    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        children: [
          TextFormField(
            autovalidateMode: autoValidateMode,
            style: context.textTheme.bodyMedium,
            obscureText: obscureText,
            enabled: enabled,
            onChanged: onChanged,
            focusNode: focusNode,
            autocorrect: autocorrect,
            autofocus: autofocus,
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction ?? TextInputAction.done,
            maxLines: maxLines,
            maxLength: maxLength,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              // helperText: validator != null ? "" : null,
              // helperStyle: context.textTheme.bodySmall,
              errorStyle: context.textTheme.bodySmall?.copyWith(
                color: context.theme.colorScheme.error,
              ),
              errorMaxLines: 2,
              isDense: true,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 28,
                minHeight: 28,
              ),
              filled: true,
              fillColor: fillColor,
              contentPadding: effectiveContentPadding,
              border: border,
              enabledBorder: enableBorder,
              disabledBorder: border,
              errorBorder: errorBorder,
              focusedErrorBorder: focusErrorBorder,
              focusedBorder: focusedBorder,
              hintText: hintText,
              hintStyle: context.textTheme.bodyMedium?.copyWith(
                color: $styles.color.clrGrey,
              ),
            ),
            validator: validator,
            onFieldSubmitted: onFieldSubmitted,
          ),
        ],
      ),
    );
  }
}
