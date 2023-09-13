import 'package:flutter/material.dart';
import '../core.dart';

class DefaultStateBuilder<L extends Exception, R> extends StatelessWidget {
  const DefaultStateBuilder({
    super.key,
    required this.state,
    required this.builder,
    this.onSuccess,
    this.onError,
    this.onInitial,
    this.onLoading,
  });
  final ValueNotifier<DefaultState<L, R>> state;

  final Widget Function(SuccessState<L, R> state)? onSuccess;
  final Widget Function(ErrorState<L, R> state)? onError;
  final Widget Function(InitialState<L, R> state)? onInitial;
  final Widget Function(LoadingState<L, R> state)? onLoading;

  final Widget Function(BuildContext context, DefaultState<L, R> state) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: state,
      builder: (context, value, child) {
        if (value is LoadingState && onLoading != null) {
          return onLoading!(value as LoadingState<L, R>);
        } else if (value is ErrorState && onError != null) {
          return onError!(value as ErrorState<L, R>);
        } else if (value is SuccessState && onSuccess != null) {
          return onSuccess!(value as SuccessState<L, R>);
        } else if (value is InitialState && onInitial != null) {
          return onInitial!(value as InitialState<L, R>);
        }

        return builder(context, value);
      },
    );
  }
}
