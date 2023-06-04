abstract class DefaultState<L extends Exception, R> {}

class InitialState<L extends Exception, R> implements DefaultState<L, R> {}

class LoadingState<L extends Exception, R> implements DefaultState<L, R> {}

class SuccessState<L extends Exception, R> implements DefaultState<L, R> {
  final R data;
  const SuccessState(
    this.data,
  );
}

class ErrorState<L extends Exception, R> implements DefaultState<L, R> {
  const ErrorState(
    this.exception, {
    this.type,
  });
  final L exception;
  final Type? type;
}
