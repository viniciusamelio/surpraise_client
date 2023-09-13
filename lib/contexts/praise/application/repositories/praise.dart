import '../../../../core/core.dart';

abstract class PraiseRepository {
  AsyncAction<void> send(PraiseInput input);
}
