import 'package:flutter/material.dart';

import '../../shared/shared.dart';
import '../core.dart';
import '../external_dependencies.dart';

mixin BaseState<L extends Exception, R> {
  final AtomNotifier<DefaultState<L, R>> state =
      AtomNotifier(InitialState<L, R>());

  void stateFromEither(Either<L, R> either) => state.set(
        either.fold(
          (left) {
            return ErrorState(left, type: left.runtimeType);
          },
          (right) => SuccessState(right),
        ),
      );

  void setDefaultErrorHandling() async {
    state.on<ErrorState<L, R>>((left) {
      final context = navigatorKey.currentContext!;

      ScaffoldMessenger.of(context).showSnackBar(
        ErrorSnack(message: left.toString()).build(
          context,
        ),
      );
    });
  }
}

extension ListenState<L extends Exception, R>
    on AtomNotifier<DefaultState<L, R>> {
  void listenState({
    void Function(L left)? onError,
    void Function(R right)? onSuccess,
    VoidCallback? onLoading,
  }) {
    listen(
      (value) {
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
