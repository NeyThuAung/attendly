enum Flavor {
  local,
  staging,
  prod,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.local:
        return 'Attendly Local';
      case Flavor.staging:
        return 'Attendly Staging';
      case Flavor.prod:
        return 'Attendly';
    }
  }

}
