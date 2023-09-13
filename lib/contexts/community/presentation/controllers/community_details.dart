import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart' hide CommunityRepository;
import '../../../../shared/shared.dart';
import '../../application/application.dart';
import '../../dtos/dtos.dart';

abstract class CommunityDetailsController
    extends BaseStateController<List<FindCommunityMemberOutput>> {
  Future<void> getMembers({required String id});
  AtomNotifier<String> get memberFilter;

  AtomNotifier<DefaultState<Exception, void>> get leaveState;
  Future<void> leave({
    required String communityId,
  });

  AtomNotifier<bool> get showSearchbar;

  void dispose();
}

class DefaultCommunityDetailsController
    with BaseState<Exception, List<FindCommunityMemberOutput>>
    implements CommunityDetailsController {
  DefaultCommunityDetailsController({
    required CommunityRepository communityRepository,
    required SessionController sessionController,
  })  : _communityRepository = communityRepository,
        _sessionController = sessionController {
    setDefaultErrorHandling();
  }
  final CommunityRepository _communityRepository;
  final SessionController _sessionController;

  @override
  Future<void> getMembers({required String id}) async {
    state.set(LoadingState());
    final membersOrError = await _communityRepository.getCommunityMembers(id);
    stateFromEither(membersOrError);
  }

  @override
  Future<void> leave({required String communityId}) async {
    leaveState.set(LoadingState());
    final leaveResponseOrError = await _communityRepository.leaveCommunity(
      communityId: communityId,
      memberId: _sessionController.currentUser!.id,
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
