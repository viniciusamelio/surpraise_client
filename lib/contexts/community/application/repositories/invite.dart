import '../../../../core/core.dart';

abstract class InviteRepository {
  AsyncAction<void> inviteMember({
    required String tag,
    required String communityId,
    required Role role,
  });
}
