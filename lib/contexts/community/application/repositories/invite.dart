import '../../../../core/core.dart';

abstract class InviteRepository {
  AsyncAction<void> answerInvitation({
    required String inviteId,
    required bool accepted,
  });
}
