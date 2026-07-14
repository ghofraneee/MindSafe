import 'package:equatable/equatable.dart';

/// Base class for domain and infrastructure failures.
sealed class Failure extends Equatable {
  const Failure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => '$runtimeType: $message';
}

/// Failure when reading or writing to local cache or storage.
final class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Failure related to authentication or authorization.
final class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

/// Failure caused by invalid user input or business rule validation.
final class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

/// Catch-all failure for unexpected errors.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred. Please try again.',
  });
}
