import 'package:flutter/material.dart';

import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';

class CustomConfirmDialog extends StatelessWidget {
  const CustomConfirmDialog({
    super.key,
    required this.onYes,
    required this.onNo,
    required this.title,
    required this.description,
    required this.icon,
    this.yesText = "Yes",
    this.noText = "No",
  });

  final VoidCallback onYes;
  final VoidCallback onNo;

  final String title;
  final String description;
  final String icon;

  final String yesText;
  final String noText;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFE9E9E9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Top Icon
            SizedBox(
              width: $styles.size.size800,
              height: $styles.size.size800,
              child: Image.asset(icon),
            ),

            $styles.insets.sm.toHeightSizedBox,

            /// Title
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: context.textTheme.titleSmall?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),

            $styles.insets.xs.toHeightSizedBox,

            /// Description
            Text(
              description,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.8,
              ),
            ),

            const SizedBox(height: 32),

            /// Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onNo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: $styles.insets.xs + 6,
                      ),
                      child: Text(
                        noText,
                        style: context.textTheme.bodySmall?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: $styles.color.clrWhite,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: ElevatedButton(
                    onPressed: onYes,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC928),
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: $styles.insets.xs + 6,
                      ),
                      child: Text(
                        yesText,
                        style: context.textTheme.bodySmall?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: $styles.color.clrBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
