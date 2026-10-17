import 'failure.dart';

class AppFailure extends Failure {
  const AppFailure(super.reason);
}

class AuthFailure extends Failure {
  const AuthFailure(super.reason);
}

class LocationFailure extends Failure {
  const LocationFailure(super.reason);
}
