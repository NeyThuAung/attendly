import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:attendly/app.dart';
import 'package:attendly/core/storage/storage.dart';
import 'package:attendly/di/injector.dart';
import 'package:attendly/features/auth/domain/entity/user_entity.dart';
import 'package:attendly/features/auth/presentation/cubit/authentication_cubit.dart';
import 'package:attendly/navigation/index_page.dart';
import 'package:attendly/shared/components/modal/language_bottom_sheet.dart';
import 'package:attendly/shared/components/modal/logout_modal.dart';
import 'package:attendly/shared/components/tile/setting_row_tile.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import 'package:attendly/shared/styles/styles.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const String routeName = "profile";
  static const String routePath = "/$routeName";

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthenticationCubit>();
    final user = authCubit.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : $styles.color.clrSoftGrey;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          $styles.insets.sm,
          $styles.insets.sm,
          $styles.insets.sm,
          context.bottomPadding + 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// User Profile Information Card
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: cardBorderColor, width: 1),
              ),
              color: isDark ? context.theme.cardColor : Colors.white,
              child: Padding(
                padding: EdgeInsets.all($styles.insets.md),
                child: Row(
                  children: [
                    /// Profile Avatar
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: $styles.color.clrPrimary.withValues(alpha: 0.1),
                      backgroundImage: (user?.profileImageUrl?.isNotEmpty == true)
                          ? CachedNetworkImageProvider(user!.profileImageUrl!)
                          : null,
                      child: (user?.profileImageUrl?.isNotEmpty != true)
                          ? Text(
                              (user?.name.isNotEmpty == true)
                                  ? user!.name[0].toUpperCase()
                                  : 'U',
                              style: context.textTheme.headlineMedium?.copyWith(
                                color: $styles.color.clrPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    $styles.insets.md.toWidthSizedBox,

                    /// User Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'User Name',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          $styles.insets.xxs.toHeightSizedBox,
                          Text(
                            user?.email ?? 'user@email.com',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: $styles.color.clrDarkGrey,
                            ),
                          ),
                          $styles.insets.xs.toHeightSizedBox,
                          Chip(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            visualDensity: VisualDensity.compact,
                            label: Text(
                              (user?.role == UserRole.admin ? 'ADMIN' : 'EMPLOYEE'),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: user?.role == UserRole.admin
                                ? Colors.indigo
                                : $styles.color.clrPrimary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            $styles.insets.lg.toHeightSizedBox,

            Text(
              'App Settings',
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: $styles.color.clrDarkGrey,
              ),
            ),
            $styles.insets.xs.toHeightSizedBox,

            /// Settings Options Card
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: cardBorderColor, width: 1),
              ),
              color: isDark ? context.theme.cardColor : Colors.white,
              child: Column(
                children: [
                  /// Dark Theme Toggle
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: themeNotifier,
                    builder: (context, themeMode, _) {
                      final isDark = themeMode == ThemeMode.dark;
                      return SettingRowTile(
                        icon: Icons.dark_mode_outlined,
                        label: 'Dark Mode',
                        status: Switch(
                          value: isDark,
                          onChanged: (val) {
                            themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                            inject<Storage>().saveIsDarkMode(val);
                          },
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),

                  /// Change Language Option
                  SettingRowTile(
                    icon: Icons.language_outlined,
                    label: 'Language',
                    status: Text(
                      context.locale.languageCode.toUpperCase(),
                      style: context.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: $styles.color.clrPrimary,
                      ),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: context.theme.scaffoldBackgroundColor,
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => const LanguageBottomSheet(),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),

                  /// Logout Option
                  SettingRowTile(
                    icon: Icons.logout_outlined,
                    label: 'Logout',
                    onTap: () {
                      showLogoutConfirmation(context, () {
                        IndexPage.lastTab = 0;
                        context.read<AuthenticationCubit>().logout();
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
