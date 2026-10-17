import 'package:firebase_core/firebase_core.dart';
import 'package:attendly/core/exceptions/remote_exception.dart';

extension FirebaseExceptionMapper on FirebaseException {
  RemoteException toRemoteException() {
    final cleanCode = code.toLowerCase();

    return switch (cleanCode) {
      // Firebase Authentication Errors
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => const UnAuthorizedException(
        'Invalid email or password credentials.',
      ),
      'invalid-email' => const BadRequestException(
        'The email address is badly formatted.',
      ),
      'user-disabled' => PermissionDeniedException(
        message ?? 'This user account has been disabled.',
      ),
      'email-already-in-use' => const BadRequestException(
        'An account already exists with this email.',
      ),
      'weak-password' => BadRequestException(
        message ?? 'The password provided is too weak.',
      ),
      'too-many-requests' => const ServerException(
        'Too many login requests. Please try again later.',
      ),

      // Cloud Firestore Errors
      'not-found' || 'object-not-found' => NotFoundException(
        message ?? 'The requested resource could not be found.',
      ),
      'permission-denied' || 'unauthorized' => PermissionDeniedException(
        message ?? 'You do not have permission to perform this action.',
      ),
      'already-exists' => BadRequestException(
        message ?? 'The resource you are trying to create already exists.',
      ),
      'resource-exhausted' || 'quota-exceeded' => ServerException(
        message ?? 'Quota or storage limit exceeded. Please try again later.',
      ),
      'unavailable' => ServerException(
        message ?? 'The service is currently unavailable. Check your network connection.',
      ),
      'deadline-exceeded' || 'retry-limit-exceeded' => TimeoutException(
        message ?? 'The operation timed out. Please try again.',
      ),

      // Firebase Storage Specific Errors
      'bucket-not-found' || 'project-not-found' => ServerException(
        message ?? 'Storage bucket or configuration error.',
      ),
      'unauthenticated' => UnAuthorizedException(
        message ?? 'User is unauthenticated. Please sign in.',
      ),
      'canceled' => UnknownNetworkException(
        message ?? 'The operation was canceled.',
      ),

      // Default Fallback
      _ => UnknownNetworkException(
        message ?? 'An unknown Firebase error occurred ($code).',
      ),
    };
  }
}
