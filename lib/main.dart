import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'core/storage/storage.dart';
import 'di/di.dart';
import 'firebase_options.dart';
import 'flavors.dart';
import 'features/auth/presentation/cubit/authentication_cubit.dart';
import 'features/auth/presentation/cubit/authentication_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await EasyLocalization.ensureInitialized();

  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
    orElse: () => Flavor.prod,
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies();

  final storage = inject<Storage>();
  final isDark = await storage.getIsDarkMode();
  themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;

  final authCubit = inject<AuthenticationCubit>();
  await _waitForResolvedAuthState(authCubit);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('my')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const App(),
    ),
  );
}

Future<void> _waitForResolvedAuthState(AuthenticationCubit cubit) {
  if (cubit.state is! AuthenticationLoading) {
    return Future.value();
  }
  return cubit.stream.firstWhere((state) => state is! AuthenticationLoading);
}
