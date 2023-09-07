import '../core.dart';
import '../external_dependencies.dart';

abstract class BaseStateController<R> {
  AtomNotifier<DefaultState<Exception, R>> get state;
}
