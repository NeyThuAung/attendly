import 'package:flutter/material.dart';
import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import '../button/confirm_cancel_row_button.dart';

void showLogoutConfirmation(BuildContext context, void Function() onPressed) {
  showModalBottomSheet(
    context: context,
    backgroundColor: context.theme.scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext modalContext) {
      return Wrap(
        children: [
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ($styles.insets.sm / 1.5).toHeightSizedBox,
                Text(
                  "Are you sure you want to logout?",
                  style: modalContext.textTheme.bodyMedium,
                ),
                ($styles.insets.sm).toHeightSizedBox,
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: $styles.grid.columnsMargin,
              left: $styles.grid.columnsMargin,
              bottom: $styles.grid.columnsMargin + $styles.insets.sm,
            ),
            child: ConfirmCancelRowButton(
              confirmTitle: "Logout",
              onPressed: () {
                Navigator.of(modalContext).pop();
                onPressed();
              },
            ),
          ),
        ],
      );
    },
  );
}
