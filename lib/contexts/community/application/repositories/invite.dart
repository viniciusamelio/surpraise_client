import '../../../../core/core.dart';

abstract class InviteRepository {
  AsyncAction<void> inviteMember({
    required String memberId,
    required String communityId,
    required Role role,
  });
}
