import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/injector.dart';
import '../features/admin/presentation/pages/dashboard/cubit/admin_dashboard_cubit.dart';
import '../features/admin/presentation/pages/user_history/cubit/admin_history_cubit.dart';
import '../features/admin/presentation/pages/users_list/cubit/users_list_cubit.dart';
import '../features/attendance/presentation/pages/history/cubit/user_history_cubit.dart';
import '../features/attendance/presentation/pages/home/cubit/home_page_cubit.dart';
import '../features/auth/domain/entity/user_entity.dart';
import '../features/auth/presentation/cubit/authentication_cubit.dart';
import '../features/auth/presentation/pages/profile/profile_page.dart';
import '../features/attendance/presentation/pages/home/user_home_page.dart';
import '../features/attendance/presentation/pages/history/user_history_page.dart';
import '../features/admin/presentation/pages/dashboard/admin_dashboard_page.dart';
import '../features/admin/presentation/pages/users_list/users_list_page.dart';
import '../features/admin/presentation/pages/user_history/admin_history_page.dart';
import '../navigation/navigation_key_provider.dart';
import '../shared/components/nav_bar/modern_bottom_nav_bar.dart';
import '../shared/components/nav_bar/nav_item.dart';

class IndexPage extends StatelessWidget {
  final int initialTab;
  final void Function(int index)? onIndexChanged;
  final void Function(void Function(int page) Function())? indexCallback;

  const IndexPage({
    super.key,
    this.initialTab = 0,
    this.onIndexChanged,
    this.indexCallback,
  });

  static const String routeName = "index";
  static const String routePath = "/";

  static int? lastTab;

  @override
  Widget build(BuildContext context) {
    inject<INavigationKeyProvider>().scaffoldContext = context;

    final ValueNotifier<int> currentIndex = ValueNotifier<int>(
      lastTab ?? initialTab,
    );

    indexCallback?.call(() {
      return (int index) {
        currentIndex.value = index;
        lastTab = index;
        onIndexChanged?.call(index);
      };
    });

    final userRole = context.read<AuthenticationCubit>().currentUser?.role ?? UserRole.user;

    return ValueListenableBuilder<int>(
      valueListenable: currentIndex,
      builder: (BuildContext context, int index, Widget? child) {
        final List<Widget> pages = userRole == UserRole.admin
            ? const [
                AdminDashboardPage(),
                UsersListPage(),
                AdminHistoryPage(),
                ProfilePage(),
              ]
            : const [
                UserHomePage(),
                UserHistoryPage(),
                ProfilePage(),
              ];

        final List<NavItem> navItems = userRole == UserRole.admin
            ? const [
                NavItem(
                  icon: Icons.dashboard_outlined,
                  selectedIcon: Icons.dashboard,
                  label: 'Dashboard',
                ),
                NavItem(
                  icon: Icons.people_outline,
                  selectedIcon: Icons.people,
                  label: 'Users',
                ),
                NavItem(
                  icon: Icons.history_outlined,
                  selectedIcon: Icons.history,
                  label: 'History',
                ),
                NavItem(
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  label: 'Profile',
                ),
              ]
            : const [
                NavItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: 'Home',
                ),
                NavItem(
                  icon: Icons.history_outlined,
                  selectedIcon: Icons.history,
                  label: 'History',
                ),
                NavItem(
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  label: 'Profile',
                ),
              ];

        return Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: index,
            children: pages,
          ),
          bottomNavigationBar: Builder(
            builder: (context) {
              return ModernBottomNavBar(
                currentIndex: index,
                items: navItems,
                onTap: (newIndex) {
                  if (userRole == UserRole.admin) {
                    if (newIndex == 0) context.read<AdminDashboardCubit>().loadSummary(forceReload: true);
                    if (newIndex == 1) context.read<UsersListCubit>().searchUsers(forceReload: true);
                    if (newIndex == 2) context.read<AdminHistoryCubit>().init(forceReload: true);
                  } else {
                    if (newIndex == 0) {
                      final cubit = context.read<HomePageCubit>();
                      cubit.fetchLastAttendanceStatus();
                      if (cubit.state.currentLocation == null) {
                        cubit.fetchLocationAndStatus();
                      }
                    }
                    if (newIndex == 1) context.read<UserHistoryCubit>().loadHistory(showLoading: true);
                  }

                  currentIndex.value = newIndex;
                  lastTab = newIndex;
                  onIndexChanged?.call(newIndex);
                },
              );
            },
          ),
        );
      },
    );
  }
}
