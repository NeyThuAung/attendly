import 'package:flutter/material.dart';

class DismissFocusWrapper extends StatelessWidget {
  final Widget child;
  final List<FocusNode>? focuses;

  const DismissFocusWrapper({super.key, required this.child, this.focuses});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _dismissCurrentFocus(context);

        if (focuses != null) {
          for (FocusNode focus in focuses!) {
            focus.unfocus();
          }
        }
      },
      child: child,
    );
  }

  void _dismissCurrentFocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
