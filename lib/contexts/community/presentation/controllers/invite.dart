import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart' hide CommunityRepository;
import '../../application/application.dart';

abstract class InviteController extends BaseStateController<void> {
  Future<void> invite({
    required String memberId,
    required Role role,
    required String communityId,
  });

  AtomNotifier<DefaultState<Exception, GetUserOutput>> get userSearchState;
  Future<void> getUserFromTag(String tag);

  AtomNotifier<Role?> get selectedRole;

  void dispose();
}

class DefaultInviteController
    with BaseState<Exception, void>
    implements InviteController {
  DefaultInviteController({
    required InviteRepository inviteRepository,
    required GetUserByTagQuery getUserByTagQuery,
  })  : _inviteRepository = inviteRepository,
        _userByTagQuery = getUserByTagQuery {
    setDefaultErrorHandling();
  }

  final InviteRepository _inviteRepository;
  final GetUserByTagQuery _userByTagQuery;

  @override
  Future<void> invite({
    required String memberId,
    required Role role,
    required String communityId,
  }) async {
    state.set(LoadingState());
    final invitedMemberResultOrError = await _inviteRepository.inviteMember(
      memberId: memberId,
      communityId: communityId,
      role: role,
    );
    stateFromEither(invitedMemberResultOrError);
  }

  @override
  Future<void> getUserFromTag(String tag) async {
    userSearchState.set(LoadingState());
    final usersOrError = await _userByTagQuery(
      GetUserByTagQueryInput(
        tag: "@$tag",
      ),
    );
    userSearchState.set(usersOrError.fold(
      (left) => ErrorState(left),
      (right) => SuccessState(
        GetUserOutput(
          tag: tag,
          name: right.value.name,
          email: right.value.email,
          id: right.value.id,
        ),
      ),
    ));
  }

  @override
  late final AtomNotifier<DefaultState<Exception, GetUserOutput>>
      userSearchState = AtomNotifier(
    InitialState(),
  );

  @override
  void dispose() {
    userSearchState.set(InitialState());
    state.set(InitialState());
    selectedRole.set(null);
  }

  @override
  final AtomNotifier<Role?> selectedRole = AtomNotifier(null);
}
