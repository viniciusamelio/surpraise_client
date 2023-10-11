import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';

abstract class InviteRepository {
  AsyncAction<void> inviteMember({
    required String memberId,
    required String communityId,
    required Role role,
  });

  AsyncAction<void> answerInvitation({
    required String inviteId,
    required bool accepted,
  });
}
