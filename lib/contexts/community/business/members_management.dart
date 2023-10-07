import '../../../core/core.dart';
import '../../../shared/shared.dart';
import '../dtos/dtos.dart';

bool currentUserCanManageMembers({
  required CommunityOutput community,
}) {
  return [Role.moderator, Role.admin].contains(community.role);
}

bool currentUserIsOwner({required CommunityOutput community}) {
  return community.ownerId ==
      injected<SessionController>().currentUser.value!.id;
}

bool currentUserCanRemoveThisMember({
  required CommunityOutput community,
  required FindCommunityMemberOutput member,
}) {
  final canEdit = currentUserCanManageMembers(community: community);
  final owner = currentUserIsOwner(community: community);
  final memberRole = Role.fromString(
    member.role,
  );
  if ((canEdit && memberRole.level < community.role.level) || owner) {
    return true;
  }
  return false;
}
