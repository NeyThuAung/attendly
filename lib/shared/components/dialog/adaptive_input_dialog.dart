import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../text_form_field/text_form_field.dart';

/// Helper function for showing an adaptive dialog with a TextFormField
/// Returns:
/// - The entered text when the user confirms
/// - null if cancelled or dismissed
Future<String?> showAdaptiveTextInputDialog({
  required BuildContext context,
  String? title,
  Widget? content,
  String? hintText,
  String? initialValue,
  String? cancelActionText,
  required String defaultActionText,
  bool barrierDismissible = true,
  bool isDestructive = false,
  TextInputType keyboardType = TextInputType.text,
  bool autofocus = false,
  TextEditingController? initialController,
}) {
  final TextEditingController controller = TextEditingController(
    text: initialValue ?? '',
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FocusScope.of(context).requestFocus(FocusNode());

  return showAdaptiveDialog<String?>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) => AlertDialog.adaptive(
      title: title != null ? Text(title) : null,
      content: Material(
        color: Colors.transparent,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              if (content != null) content,
              AppTextFormField(
                controller: initialController ?? controller,
                keyboardType: keyboardType,
                autofocus: autofocus,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a value";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        if (cancelActionText != null)
          _adaptiveAction(
            context: context,
            onPressed: () => Navigator.pop(context, null),
            child: Text(cancelActionText),
          ),
        _adaptiveAction(
          context: context,
          isDestructive: isDestructive,
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              Navigator.pop(
                context,
                initialController != null
                    ? initialController.text.trim()
                    : controller.text.trim(),
              );
            }
          },
          child: Text(defaultActionText),
        ),
      ],
    ),
  );
}

/// Reuse the same adaptive action builder
Widget _adaptiveAction({
  required BuildContext context,
  required VoidCallback onPressed,
  required Widget child,
  bool isDestructive = false,
}) {
  final platform = Theme.of(context).platform;
  if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
    return CupertinoDialogAction(
      onPressed: onPressed,
      isDestructiveAction: isDestructive,
      child: child,
    );
  } else {
    return TextButton(onPressed: onPressed, child: child);
  }
}
