import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:attendly/flavors.dart';
import 'package:attendly/navigation/router_extension.dart';
import 'package:attendly/shared/components/button/elevated_button.dart';
import 'package:attendly/shared/components/modal/language_bottom_sheet.dart';
import 'package:attendly/shared/components/wrapper/flavor_banner.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import 'package:attendly/shared/styles/styles.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const String routeName = "welcome";
  static const String routePath = "/$routeName";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop, result) {
        if (!canPop) {
          SystemNavigator.pop();
        }
      },
      child: FlavorBanner(
        show: kDebugMode || F.appFlavor != Flavor.prod,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarContrastEnforced: false,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: $styles.grid.columnsMargin,
                  vertical: $styles.insets.sm,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Header with App Title and Language Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_filled,
                              size: 32,
                              color: $styles.color.clrPrimary,
                            ),
                            $styles.insets.xs.toWidthSizedBox,
                            Text(
                              'app_name'.tr(),
                              style: context.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: $styles.color.clrPrimary,
                              ),
                            ),
                          ],
                        ),
                        _languageSelectorButton(context),
                      ],
                    ),

                    /// Hero Time Clock Icon & Branding Section
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all($styles.insets.md),
                          decoration: BoxDecoration(
                            color: $styles.color.clrPrimary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.access_time_filled,
                            size: 90,
                            color: $styles.color.clrPrimary,
                          ),
                        ),
                        $styles.insets.md.toHeightSizedBox,
                        Text(
                          'welcome_title'.tr(),
                          style: context.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        $styles.insets.xs.toHeightSizedBox,
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: $styles.insets.sm,
                          ),
                          child: Text(
                            'welcome_subtitle'.tr(),
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: $styles.color.clrDarkGrey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    /// Action Buttons
                    Column(
                      children: [
                        CustomElevatedButton(
                          onPressed: () => context.pushLoginPage(),
                          child: Text(
                            'login_to_your_account'.tr(),
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: $styles.color.clrWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        $styles.insets.xs.toHeightSizedBox,
                        CustomElevatedButton(
                          cancelButton: true,
                          onPressed: () => context.pushRegisterPage(),
                          child: Text(
                            'create_an_account'.tr(),
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: $styles.color.clrBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        $styles.insets.xs.toHeightSizedBox,
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _languageSelectorButton(BuildContext context) {
    final currentLangCode = context.locale.languageCode; // "en" or "my"
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _showLanguageBottomSheet(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: $styles.insets.xs,
          vertical: $styles.insets.xxs + 2,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: $styles.color.clrSoftGrey, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, size: 18, color: $styles.color.clrPrimary),
            $styles.insets.xxs.toWidthSizedBox,
            Text(
              currentLangCode.toUpperCase(),
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, size: 16),
          ],
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const LanguageBottomSheet(),
    );
  }
}
