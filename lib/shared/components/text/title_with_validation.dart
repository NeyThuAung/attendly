import 'package:flutter/material.dart';

import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import '../icon/check_mark.dart';
import '../icon/svg_icon.dart';

class TitleWithValidation extends StatelessWidget {
  const TitleWithValidation({
    super.key,
    this.isValidate = false,
    required this.title,
  });

  final bool isValidate;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.visible,
          ),
        ),
        $styles.insets.xs.toWidthSizedBox,
        !isValidate
            ? Text(
                "*",
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleLarge?.copyWith(
                  color: Colors.red,
                ),
              )
            : CheckMark(
                iconSize: SvgIcon.kSize / 2.4,
              ),
      ],
    );
  }
}

class ValidatedTitleWithController extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String? Function(String value)? validator;

  const ValidatedTitleWithController({
    super.key,
    required this.title,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (_, value, __) {
        final text = value.text.trim();

        final isValid = validator == null
            ? text.isNotEmpty
            : validator!(text) == null;

        return TitleWithValidation(
          title: title,
          isValidate: isValid,
        );
      },
    );
  }
}
