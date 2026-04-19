/// Base exception for all Aether app errors.
/// Use typed subclasses in catch blocks to show the right message to the user.
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// HTTP / network-level errors (no connection, timeout, server error).
class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error. Check your connection.']);
}

/// The server returned a 401 or the local token is invalid/expired.
class AuthException extends AppException {
  const AuthException([super.message = 'Authentication failed. Please log in again.']);
}

/// A requested resource was not found (HTTP 404).
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'The requested resource was not found.']);
}

/// The request was rejected due to invalid input (HTTP 400/422).
class ValidationException extends AppException {
  const ValidationException([super.message = 'Invalid input. Please check your data.']);
}

/// Something unexpected happened that doesn't fit the above categories.
class UnknownException extends AppException {
  const UnknownException([super.message = 'An unexpected error occurred.']);
}
