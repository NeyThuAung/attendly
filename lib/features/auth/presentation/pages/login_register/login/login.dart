import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:attendly/navigation/navigation.dart';
import 'package:attendly/shared/components/button/elevated_button.dart';
import 'package:attendly/shared/components/checkbox/remember_employee_check_box.dart';
import 'package:attendly/shared/components/loading/loading_overlay.dart';
import 'package:attendly/shared/components/text_form_field/ps_text_form_field.dart';
import 'package:attendly/shared/components/text_form_field/text_form_field.dart';
import 'package:attendly/shared/components/wrapper/dismiss_focus_wrapper.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import 'package:attendly/shared/styles/styles.dart';
import 'cubit/login_cubit.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  static const String routeName = "login";
  static const String routePath = "/$routeName";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LoginCubit>();
    final statusBarHeight = MediaQuery.paddingOf(context).top;

    return BlocSelector<LoginCubit, LoginState, bool>(
      selector: (state) {
        return switch (state) {
          LoginInitial() => state.loginLoading,
          _ => false,
        };
      },
      builder: (context, isLoading) {
        return BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              context.goIndexAndSelectTab(0);
            }
          },
          builder: (context, state) {
            final saveEmail = state is LoginInitial && state.saveEmail;

            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.light,
                systemNavigationBarColor: Colors.transparent,
                systemNavigationBarContrastEnforced: false,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
              child: DismissFocusWrapper(
                child: LoadingOverlay(
                  isLoading: isLoading,
                  loadingInfo: "Logging in...",
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    extendBodyBehindAppBar: true,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      surfaceTintColor: Colors.transparent,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.goWelcomePage();
                          }
                        },
                      ),
                    ),
                    body: Column(
                      children: [
                        /// Dark Header Section
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D0D1B),
                            image: DecorationImage(
                              image: AssetImage(R.images.loginBackgroundPattern),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {},
                            ),
                          ),
                          padding: EdgeInsets.only(
                            top: kToolbarHeight + statusBarHeight,
                            left: $styles.grid.columnsMargin,
                            right: $styles.grid.columnsMargin,
                            bottom: $styles.grid.columnsMargin + 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              $styles.insets.xs.toHeightSizedBox,
                              Text(
                                'Sign in to your\nAccount',
                                style: context.textTheme.titleLarge?.copyWith(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: $styles.color.clrWhite,
                                ),
                              ),
                              $styles.insets.xs.toHeightSizedBox,
                              Text(
                                'Enter your email and password to log in.',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: $styles.color.clrWhite,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Form Content
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.only(
                              left: $styles.grid.columnsMargin,
                              right: $styles.grid.columnsMargin,
                              top: $styles.grid.columnsMargin * 1.5,
                              bottom: $styles.grid.columnsMargin,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  AppTextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    autoValidateMode: AutovalidateMode.onUserInteraction,
                                    textInputAction: TextInputAction.next,
                                    controller: bloc.emailController,
                                    hintText: "Email",
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(
                                        left: $styles.insets.xs * 1.5,
                                        right: $styles.insets.xs,
                                      ),
                                      child: SvgPicture.asset(
                                        R.icons.email,
                                        width: 20,
                                        height: 20,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.email, size: 20),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return "Email cannot be empty.";
                                      }
                                      if (!value.contains('@')) {
                                        return "Please enter a valid email address.";
                                      }
                                      return null;
                                    },
                                  ),
                                  $styles.size.size200.toHeightSizedBox,
                                  PasswordTextFormField(
                                    controller: bloc.passwordController,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return "Password cannot be empty.";
                                      }
                                      return null;
                                    },
                                  ),
                                  $styles.size.size100.toHeightSizedBox,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      RememberEmployeeCheckbox(
                                        value: saveEmail,
                                        onChanged: bloc.onChangeSaveEmployeeNo,
                                      ),
                                    ],
                                  ),
                                  $styles.size.size300.toHeightSizedBox,

                                  /// Log In Button
                                  CustomElevatedButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      if (_formKey.currentState?.validate() == true) {
                                        bloc.logIn();
                                      }
                                    },
                                    child: Text(
                                      'Log In',
                                      style: context.textTheme.bodyMedium?.copyWith(
                                        color: $styles.color.clrWhite,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        /// Sign Up Link
                        SafeArea(
                          top: false,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: $styles.size.size300),
                            child: GestureDetector(
                              onTap: () {
                                context.pushRegisterPage();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: context.textTheme.bodyMedium?.copyWith(
                                      fontSize: 13,
                                      color: $styles.color.clrGrey,
                                    ),
                                  ),
                                  Text(
                                    "Sign Up",
                                    style: context.textTheme.bodyMedium?.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: $styles.color.clrPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
