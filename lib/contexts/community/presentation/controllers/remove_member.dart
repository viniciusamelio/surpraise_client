import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/shared.dart';

abstract class RemoveMemberController extends BaseStateController {
  Future<void> removeMember({
    required FindCommunityMemberOutput member,
    required CommunityOutput community,
  });
}

class DefaultRemoveMemberController
    with BaseState<Exception, void>
    implements RemoveMemberController {
  DefaultRemoveMemberController({
    required RemoveMembersUsecase removeMembersUsecase,
  }) : _removeMembersUsecase = removeMembersUsecase;
  final RemoveMembersUsecase _removeMembersUsecase;

  @override
  Future<void> removeMember({
    required FindCommunityMemberOutput member,
    required CommunityOutput community,
  }) async {
    state.set(LoadingState());
    final removedMemberResponseOrError = await _removeMembersUsecase(
      RemoveMembersInput(
        communityId: community.id,
        reason: "",
        moderator: MemberDto(
          id: injected<SessionController>().currentUser.value!.id,
          role: community.role.value,
        ),
        members: [
          MemberDto(
            id: member.id,
            role: member.role,
          ),
        ],
      ),
    );
    stateFromEither(removedMemberResponseOrError);
  }
}
