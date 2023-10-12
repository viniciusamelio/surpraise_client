import '../../../../core/core.dart' hide InviteRepository;
import '../../../../shared/shared.dart';
import '../../../community/community.dart';
import '../../application/events/events.dart';

abstract class AnswerInviteController extends BaseStateController<void> {
  Future<void> answerInvite({
    required String inviteId,
    required bool accept,
  });
}

class DefaultAnswerInviteController
    with BaseState<Exception, void>
    implements AnswerInviteController {
  DefaultAnswerInviteController({
    required InviteRepository inviteRepository,
    required SessionController sessionController,
  }) : _repository = inviteRepository {
    setDefaultErrorHandling();
  }
  final InviteRepository _repository;

  @override
  Future<void> answerInvite({
    required String inviteId,
    required bool accept,
  }) async {
    state.set(LoadingState());
    final inviteOrError = await _repository.answerInvitation(
      inviteId: inviteId,
      accepted: accept,
    );
    state.set(
      inviteOrError.fold(
        (left) => ErrorState(left),
        (right) {
          injected<ApplicationEventBus>().add(InviteAnsweredEvent(inviteId));
          return const SuccessState(null);
        },
      ),
    );
  }
}
