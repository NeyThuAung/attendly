import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:attendly/shared/styles/styles.dart';
import 'text_form_field.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({
    super.key,
    required this.controller,
    this.hintText,
    this.validator,
    this.prefixNeed = true,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool prefixNeed;

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  late bool isPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      autoValidateMode: AutovalidateMode.onUserInteraction,
      maxLines: 1,
      obscureText: isPasswordObscure,
      hintText: widget.hintText ?? 'Password',
      controller: widget.controller,
      prefixIcon: widget.prefixNeed
          ? Padding(
              padding: EdgeInsets.only(
                left: $styles.insets.xs * 1.5,
                right: $styles.insets.xs,
              ),
              child: SvgPicture.asset(
                R.icons.lock,
                width: 20,
                height: 20,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.lock_outline,
                  size: 20,
                  color: $styles.color.clrDarkGrey,
                ),
              ),
            )
          : null,
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            isPasswordObscure = !isPasswordObscure;
          });
        },
        icon: SvgPicture.asset(
          isPasswordObscure ? R.icons.eyeClose : R.icons.eyeOpen,
          width: 20,
          height: 20,
          errorBuilder: (context, error, stackTrace) => Icon(
            isPasswordObscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 20,
            color: $styles.color.clrDarkGrey,
          ),
        ),
      ),
      validator: widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return "Password cannot be empty.";
            }
            return null;
          },
    );
  }
}
