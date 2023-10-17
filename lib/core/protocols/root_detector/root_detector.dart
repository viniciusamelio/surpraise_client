import '../../types.dart';

abstract class RootDetector {
  AsyncAction<bool> check();
}
