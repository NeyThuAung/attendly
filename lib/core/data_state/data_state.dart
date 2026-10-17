import '../failures/failure.dart';

sealed class DataState<T> {
  final T? data;
  const DataState(this.data);

  R? onSuccess<R>(R? Function(T data) handler) {
    if (this is Success<T>) return handler(data as T);
    return null;
  }

  R? onError<R>(R? Function(Failure failure) handler) {
    if (this is Failed) return handler(((this as Failed<T>).failure));
    return null;
  }
}

final class Success<T> extends DataState<T> {
  @override
  final T data;
  const Success(this.data) : super(data);
}

final class Failed<T> extends DataState<T> {
  final Failure failure;
  final Exception? exception;
  const Failed(this.failure, [this.exception]) : super(null);
}

Failure? firstFailure(List<DataState> states) {
  for (final state in states) {
    if (state is Failed) return state.failure;
  }
  return null;
}
