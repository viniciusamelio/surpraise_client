import 'package:flutter/material.dart';
import '../core.dart';

abstract class BaseStateController<R> {
  ValueNotifier<DefaultState<Exception, R>> get state;
}
