import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart' hide CommunityRepository;
import '../../../../shared/shared.dart';
import '../../application/application.dart';
import '../../dtos/dtos.dart';

abstract class CommunityDetailsController
    extends BaseStateController<List<FindCommunityMemberOutput>> {
  Future<void> getMembers({required String id});
  AtomNotifier<String> get memberFilter;
  AtomNotifier<List<FindCommunityMemberOutput>> get filteredMembers;

  AtomNotifier<DefaultState<Exception, void>> get leaveState;
  Future<void> leave({
    required String communityId,
  });
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
  final AtomNotifier<List<FindCommunityMemberOutput>> filteredMembers =
      AtomNotifier([]);
}
