import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/pages/login_register/login/login.dart';
import '../features/auth/presentation/pages/login_register/register/register.dart';
import '../features/auth/presentation/pages/login_register/welcome.dart';
import 'index_page.dart';

extension RouterExtension on BuildContext {
  void goIndex() => go(IndexPage.routePath);

  void goIndexAndSelectTab(int page) {
    go("/?tab=$page");
  }

  void pushLoginPage() => push(LoginPage.routePath);

  void pushRegisterPage() => push(RegisterPage.routePath);

  void goWelcomePage() => go(WelcomePage.routePath);
}
