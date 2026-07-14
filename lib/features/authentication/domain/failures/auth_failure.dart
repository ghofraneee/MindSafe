/// Domain-level authentication failures with user-friendly messages.
sealed class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure()
      : super('Invalid email or password. Please try again.');
}

class EmailAlreadyExistsFailure extends AuthFailure {
  const EmailAlreadyExistsFailure()
      : super('An account with this email already exists.');
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure()
      : super('No account found with this email address.');
}

class BiometricNotEnabledFailure extends AuthFailure {
  const BiometricNotEnabledFailure()
      : super('Biometric login is not enabled for this device.');
}

class BiometricAuthFailure extends AuthFailure {
  const BiometricAuthFailure()
      : super('Biometric authentication failed. Please try again.');
}

class NoRememberedSessionFailure extends AuthFailure {
  const NoRememberedSessionFailure()
      : super('No saved session found. Sign in with your password first.');
}

class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure()
      : super('Your session has expired. Please sign in again.');
}
