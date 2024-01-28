import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart' hide CommunityRepository;
import '../../../../shared/shared.dart';

abstract class CommunityDetailsController
    extends BaseStateController<List<FindCommunityMemberOutput>> {
  Future<void> getMembers({required String id});
  AtomNotifier<String> get memberFilter;

  AtomNotifier<DefaultState<Exception, void>> get leaveState;
  Future<void> leave({
    required String communityId,
    required Role role,
  });

  AtomNotifier<bool> get showSearchbar;

  void dispose();
}

class DefaultCommunityDetailsController
    with BaseState<Exception, List<FindCommunityMemberOutput>>
    implements CommunityDetailsController {
  DefaultCommunityDetailsController({
    required SessionController sessionController,
    required LeaveCommunityUsecase leaveCommunityUsecase,
    required GetMembersQuery getMembersQuery,
  })  : _getMembersQuery = getMembersQuery,
        _leaveCommunityUsecase = leaveCommunityUsecase,
        _sessionController = sessionController {
    setDefaultErrorHandling();
  }
  final SessionController _sessionController;
  final LeaveCommunityUsecase _leaveCommunityUsecase;
  final GetMembersQuery _getMembersQuery;

  @override
  Future<void> getMembers({required String id}) async {
    state.set(LoadingState());
    final membersOrError = await _getMembersQuery(
      GetMembersInput(
        communityId: id,
      ),
    );
    state.set(membersOrError.fold(
      (left) => ErrorState(left),
      (right) {
        final List<FindCommunityMemberOutput> value = right.value;
        final Set<String> uniqueMemberTags = value.map((e) => e.tag).toSet();

        return SuccessState(
          uniqueMemberTags
              .map(
                (e) => value.lastWhere(
                  (element) => element.tag == e,
                ),
              )
              .toList(),
        );
      },
    ));
  }

  @override
  Future<void> leave({
    required String communityId,
    required Role role,
  }) async {
    leaveState.set(LoadingState());
    final leaveResponseOrError = await _leaveCommunityUsecase(
      LeaveCommunityInput(
        communityId: communityId,
        memberId: _sessionController.currentUser.value!.id,
        memberRole: role.value,
      ),
    );
    leaveState.set(
      leaveResponseOrError.fold(
        (left) => ErrorState(left),
        (right) => const SuccessState(null),
      ),
    );
  }

  @override
  final AtomNotifier<DefaultState<Exception, void>> leaveState =
      AtomNotifier(InitialState());

  @override
  final AtomNotifier<String> memberFilter = AtomNotifier("");

  @override
  final AtomNotifier<bool> showSearchbar = AtomNotifier(false);

  @override
  void dispose() {
    showSearchbar.set(false);
    memberFilter.set("");
    leaveState.set(InitialState());
    state.set(InitialState());
  }
}
