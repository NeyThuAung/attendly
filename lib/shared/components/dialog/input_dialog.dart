import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import '../button/elevated_button.dart';
import '../text_form_field/text_form_field.dart';
import '../wrapper/dismiss_focus_wrapper.dart';

void showInputDialog(
  BuildContext context, {
  required void Function(String value) onConfirm,
  required String title,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return DismissFocusWrapper(
        child: InputDialogView(
          onAdd: onConfirm,
          title: title,
        ),
      );
    },
  );
  //This is to remove previous focuses
  FocusScope.of(context).requestFocus(FocusNode());
}

class InputDialogView extends StatefulWidget {
  const InputDialogView({
    super.key,
    required this.onAdd,
    required this.title,
  });

  final Function(
    String value,
  ) onAdd;
  final String title;

  @override
  State<InputDialogView> createState() => _InputDialogViewState();
}

class _InputDialogViewState extends State<InputDialogView> {
  final _voucherController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _voucherController.dispose();
    debugPrint("Dialog UI disposed");
  }

  @override
  Widget build(BuildContext context) {
    bool isFormValid() {
      if (!_formKey.currentState!.validate()) {
        return false;
      }
      return true;
    }

    return Form(
      key: _formKey,
      child: Container(
        alignment: Alignment.center,
        height: context.height,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: $styles.insets.lg,
            vertical: $styles.grid.columnsMargin,
          ),
          child: Container(
            alignment: Alignment.center,
            width: min(
              min(
                context.width,
                context.height,
              ),
              $styles.size.size600 * 10,
            ),
            child: Material(
              borderRadius: BorderRadius.circular($styles.insets.xs),
              color: context.theme.scaffoldBackgroundColor,
              child: Padding(
                padding: EdgeInsets.all($styles.insets.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: context.textTheme.titleMedium,
                    ),
                    $styles.insets.xs.toHeightSizedBox,
                    AppTextFormField(
                      controller: _voucherController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
                          return "This field cannot be empty";
                        }
                        return null;
                      },
                    ),
                    $styles.insets.sm.toHeightSizedBox,
                    CustomElevatedButton(
                      onPressed: () {
                        if (isFormValid()) {
                          debugPrint("validation Success");
                          context.pop();
                          widget.onAdd(
                            _voucherController.text,
                          );
                        }
                      },
                      child:  Text("Confirm"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
