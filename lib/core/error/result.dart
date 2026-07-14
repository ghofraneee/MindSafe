import 'package:mindsafe/core/error/failures.dart';

/// A simple either-style result representing success or failure.
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Error<T>;

  T? get valueOrNull => switch (this) {
        Success<T>(:final value) => value,
        Error<T>() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        Error<T>(:final failure) => failure,
      };

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    return switch (this) {
      Success<T>(:final value) => onSuccess(value),
      Error<T>(:final failure) => onFailure(failure),
    };
  }

  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success<T>(:final value) => Success(transform(value)),
      Error<T>(:final failure) => Error(failure),
    };
  }

  Result<R> flatMap<R>(Result<R> Function(T value) transform) {
    return switch (this) {
      Success<T>(:final value) => transform(value),
      Error<T>(:final failure) => Error(failure),
    };
  }

  Result<T> onSuccess(void Function(T value) action) {
    if (this case Success<T>(:final value)) {
      action(value);
    }
    return this;
  }

  Result<T> onFailure(void Function(Failure failure) action) {
    if (this case Error<T>(:final failure)) {
      action(failure);
    }
    return this;
  }
}

/// Successful result carrying a [value].
final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

/// Failed result carrying a [Failure].
final class Error<T> extends Result<T> {
  const Error(this.failure);

  final Failure failure;
}

/// Convenience constructors for creating results.
Result<T> success<T>(T value) => Success(value);

Result<T> failure<T>(Failure failure) => Error(failure);

Result<T> tryCatch<T>(
  T Function() action, {
  Failure Function(Object error, StackTrace stackTrace)? onError,
}) {
  try {
    return Success(action());
  } catch (error, stackTrace) {
    return Error(
      onError?.call(error, stackTrace) ??
          UnexpectedFailure(message: error.toString()),
    );
  }
}
