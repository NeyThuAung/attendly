import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:attendly/shared/components/button/elevated_button.dart';
import 'package:attendly/shared/components/divider/divider.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import 'package:attendly/shared/styles/styles.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  static final List<Map<String, String>> _languages = [
    {"code": "en", "labelKey": "english"},
    {"code": "my", "labelKey": "myanmar"},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String selectedCode = context.locale.languageCode;

    final containerColor = isDark
        ? const Color(0xFF2A2A3C)
        : Colors.white;

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : $styles.color.clrSoftGrey;

    return Container(
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: StatefulBuilder(
          builder: (context, setLocalState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: $styles.insets.xs - 2),
                  child: Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade600 : $styles.color.clrGrey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: $styles.grid.columnsMargin,
                    vertical: $styles.grid.columnsMargin,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'select'.tr(),
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          $styles.insets.xxs.toHeightSizedBox,
                          Text(
                            'can_change_anytime'.tr(),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: isDark ? Colors.grey.shade400 : $styles.color.clrDarkGrey,
                            ),
                          ),
                        ],
                      ),
                      $styles.insets.md.toHeightSizedBox,
                      Container(
                        decoration: BoxDecoration(
                          color: containerColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: borderColor,
                            width: 0.8,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _languages.length,
                          separatorBuilder: (_, __) => CustomDivider(
                            color: borderColor,
                            thickness: 1,
                          ),
                          itemBuilder: (context, index) {
                            final lang = _languages[index];
                            final isSelected = selectedCode == lang["code"];
                            return InkWell(
                              onTap: () {
                                setLocalState(() => selectedCode = lang["code"]!);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: $styles.insets.sm,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        lang["labelKey"]!.tr(),
                                        style: context.textTheme.bodyMedium?.copyWith(
                                          fontSize: 14,
                                          fontWeight: isSelected ? FontWeight.bold : null,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      SvgPicture.asset(
                                        R.icons.tick,
                                        width: 20,
                                        height: 20,
                                        errorBuilder: (context, error, stackTrace) =>
                                            Icon(
                                          Icons.check_circle,
                                          color: context.theme.primaryColor,
                                          size: 20,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      $styles.insets.md.toHeightSizedBox,
                      CustomElevatedButton(
                        onPressed: () async {
                          await context.setLocale(Locale(selectedCode));
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: Text(
                          'change'.tr(),
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: $styles.color.clrWhite,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
