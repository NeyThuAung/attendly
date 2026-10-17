import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../core/services/snack_shower.dart';
import '../di/injector.dart';
import '../features/auth/presentation/cubit/authentication_cubit.dart';
import '../features/auth/presentation/cubit/authentication_state.dart';
import '../features/auth/presentation/pages/login_register/login/cubit/login_cubit.dart';
import '../features/auth/presentation/pages/login_register/login/login.dart';
import '../features/auth/presentation/pages/login_register/register/cubit/register_cubit.dart';
import '../features/auth/presentation/pages/login_register/register/register.dart';
import '../features/auth/presentation/pages/login_register/welcome.dart';
import 'authentication_router_notifier.dart';
import 'index_page.dart';
import 'navigation_key_provider.dart';

@lazySingleton
class NavigationRouter {
  final INavigationKeyProvider _navigationKeyProvider;
  final ISnackShower _snackShower;
  final AuthenticationCubit _authenticationCubit;

  NavigationRouter(
    this._navigationKeyProvider,
    this._snackShower,
    this._authenticationCubit,
  ) {
    _authNotifier = AuthenticationRouterNotifier(_authenticationCubit);
  }

  late final AuthenticationRouterNotifier _authNotifier;

  int? _currentIndex;
  void Function(int page) Function()? _useIndexPageNavigator;

  void Function(int page) Function() get useIndexPageNavigator =>
      _useIndexPageNavigator!;

  static final mustAuthenticatedRoute = [IndexPage.routePath];

  late final router = GoRouter(
    navigatorKey: _navigationKeyProvider.globalKey,
    refreshListenable: _authNotifier,
    initialLocation: IndexPage.routePath,
    redirect: (context, state) {
      final currentRoute = state.fullPath;
      final authState = context.read<AuthenticationCubit>().state;

      if (mustAuthenticatedRoute.contains(currentRoute)) {
        if (authState is AuthenticationLoading) {
          return null;
        }
        if (authState is AuthenticationUnauthenticated) {
          return WelcomePage.routePath;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        onExit: _handleDoubleTapToExit,
        path: IndexPage.routePath,
        builder: (context, state) {
          final tabIndex =
              int.tryParse(state.uri.queryParameters['tab'] ?? '') ?? 0;

          return IndexPage(
            initialTab: tabIndex,
            onIndexChanged: (index) => _currentIndex = index,
            indexCallback: (useIndexPageNavigator) {
              _useIndexPageNavigator = useIndexPageNavigator;
            },
          );
        },
        routes: [
          GoRoute(
            path: WelcomePage.routeName,
            builder: (context, state) => const WelcomePage(),
          ),
          GoRoute(
            path: LoginPage.routeName,
            builder: (context, state) {
              return BlocProvider(
                create: (context) => inject<LoginCubit>(),
                child: LoginPage(),
              );
            },
          ),
          GoRoute(
            path: RegisterPage.routeName,
            builder: (context, state) {
              return BlocProvider(
                create: (context) => inject<RegisterCubit>(),
                child: RegisterPage(),
              );
            },
          ),
        ],
      ),
    ],
  );

  DateTime? currentBackPressTime;

  Future<bool> _handleDoubleTapToExit(
    BuildContext context,
    GoRouterState state,
  ) async {
    final selectIndex = _useIndexPageNavigator?.call();
    if (selectIndex != null && _currentIndex != null && _currentIndex != 0) {
      selectIndex(0);
      return false;
    }

    final now = DateTime.now();
    const thresholdInterval = Duration(seconds: 2);

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > thresholdInterval) {
      currentBackPressTime = now;

      _snackShower.info(message: "Press again to exit app");
      return false;
    }

    return true;
  }
}
