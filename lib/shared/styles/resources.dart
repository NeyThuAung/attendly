class AppIconAssets {
  late final appLogo = "assets/icons/app_logo.svg";
  late final appLogoWhite = "assets/icons/app_logo_white.svg";
  late final email = "assets/icons/email.svg";
  late final lock = "assets/icons/lock.svg";
  late final eyeClose = "assets/icons/eye_close.svg";
  late final eyeOpen = "assets/icons/eye_open.svg";
  late final tick = "assets/icons/tick_circle.svg";
}

class AppImageAssets {
  late final logoTransparent = "assets/brand/logo_transparent.png";
  late final loginBackgroundPattern = "assets/images/login_background_pattern.png";
}

abstract class R {
  static final images = AppImageAssets();
  static final icons = AppIconAssets();
}
