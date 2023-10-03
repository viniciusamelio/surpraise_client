import '../../../../core/external_dependencies.dart';
import '../../dtos/dtos.dart';
import '../../feed.dart';

import '../../../../shared/dtos/dtos.dart';
import '../../../../core/core.dart';

abstract class FeedController extends BaseStateController<List<PraiseDto>> {
  Future<void> getPraises(String userId);

  AtomNotifier<DefaultState<Exception, List<InviteDto>>> get invitesState;
  Future<void> getInvites(String userId);

  AtomNotifier<int> get offset;
  AtomNotifier<List<PraiseDto>> get loadedPraises;
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
    state.set(LoadingState());
    final praisesOrError = await repository.get(
      userId: userId,
      offset: offset.value,
    );
    stateFromEither(praisesOrError);
    praisesOrError.fold(
      (left) => null,
      (right) => loadedPraises.set(
        loadedPraises.value
          ..addAll(
            right,
          ),
      ),
    );
  }

  @override
  Future<void> getInvites(String userId) async {
    invitesState.set(LoadingState());
    final invitesOrError = await repository.getInvites(userId: userId);
    invitesState.set(
      invitesOrError.fold(
        (left) => ErrorState(left),
        (right) => SuccessState(right),
      ),
    );
  }

  @override
  final AtomNotifier<DefaultState<Exception, List<InviteDto>>> invitesState =
      AtomNotifier(InitialState());

  @override
  AtomNotifier<int> offset = AtomNotifier(0);

  @override
  AtomNotifier<List<PraiseDto>> loadedPraises = AtomNotifier([]);
}
