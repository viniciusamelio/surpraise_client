import 'package:flutter/material.dart';
import 'package:surpraise_client/core/state/default_state.dart';

abstract class BaseStateController<R> {
  ValueNotifier<DefaultState<Exception, R>> get state;
}
