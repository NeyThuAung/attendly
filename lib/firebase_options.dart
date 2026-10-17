import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'flavors.dart';
import 'firebase_options_local.dart' as local;
import 'firebase_options_staging.dart' as staging;
import 'firebase_options_prod.dart' as prod;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (F.appFlavor) {
      case Flavor.local:
        return local.DefaultFirebaseOptions.currentPlatform;
      case Flavor.staging:
        return staging.DefaultFirebaseOptions.currentPlatform;
      case Flavor.prod:
        return prod.DefaultFirebaseOptions.currentPlatform;
    }
  }
}
