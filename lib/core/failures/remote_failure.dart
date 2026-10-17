import 'failure.dart';

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = "Not Found"]);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure([super.message = "Failed to connect"]);
}

class SessionFailure extends Failure {
  const SessionFailure([super.message = "Session timeout or unauthorized"]);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Connection time out!']);
}

class BadReqFailure extends Failure {
  const BadReqFailure([super.message = 'Bad request']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong. Please try again!']);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'You have no access permission']);
}

class UnknownNetworkFailure extends Failure {
  const UnknownNetworkFailure([super.message = 'An error occurred. Please try again!']);
}

class FirebaseFailure extends Failure {
  final String? code;
  const FirebaseFailure(super.reason, {this.code});
}
