import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
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
    required AnswerInviteUsecase answerInviteUsecase,
    required SessionController sessionController,
  }) : _usecase = answerInviteUsecase {
    setDefaultErrorHandling();
  }
  final AnswerInviteUsecase _usecase;

  @override
  Future<void> answerInvite({
    required String inviteId,
    required bool accept,
  }) async {
    state.set(LoadingState());
    final inviteOrError = await _usecase(AnswerInviteInput(
      id: inviteId,
      accepted: accept,
    ));
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
