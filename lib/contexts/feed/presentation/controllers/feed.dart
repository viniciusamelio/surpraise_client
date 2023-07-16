import '../../feed.dart';

import '../../../../shared/dtos/dtos.dart';
import '../../../../core/core.dart';

abstract class FeedController extends BaseStateController<List<PraiseDto>> {
  Future<void> getPraises(String userId);
}

class DefaultFeedController
    with BaseState<Exception, List<PraiseDto>>
    implements FeedController {
  DefaultFeedController({
    required FeedRepository feedRepository,
  }) : repository = feedRepository {
    setDefaultErrorHandling();
  }
  final FeedRepository repository;
  @override
  Future<void> getPraises(String userId) async {
    state.value = LoadingState();
    final praisesOrError = await repository.getByUser(userId: userId);
    stateFromEither(praisesOrError);
  }
}
