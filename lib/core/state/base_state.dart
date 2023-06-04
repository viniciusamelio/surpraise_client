import 'package:ez_either/ez_either.dart';
import 'package:flutter/material.dart';
import 'default_state.dart';

mixin BaseState<L extends Exception, R> {
  final ValueNotifier<DefaultState<L, R>> state =
      ValueNotifier(InitialState<L, R>());

  void stateFromEither(Either<L, R> either) => either.fold(
        (left) => state.value = ErrorState(left, type: left.runtimeType),
        (right) => state.value = SuccessState(right),
      );
}

extension ListenState<L extends Exception, R>
    on ValueNotifier<DefaultState<L, R>> {
  void listenState({
    void Function(L left)? onError,
    void Function(R right)? onSuccess,
    VoidCallback? onLoading,
  }) {
    addListener(
      () {
        if (value is LoadingState && onLoading != null) {
          onLoading();
        }
        if (value is SuccessState && onSuccess != null) {
          onSuccess((value as SuccessState).data);
        }
        if (value is ErrorState && onError != null) {
          onError((value as ErrorState<L, R>).exception);
        }
      },
    );
  }
}
