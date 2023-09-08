import '../../../../core/core.dart';
import '../../application/application.dart';
import '../../dtos/dtos.dart';

abstract class CommunityDetailsController
    extends BaseStateController<List<FindCommunityMemberOutput>> {
  Future<void> getMembers({required String id});
}

class DefaultCommunityDetailsController
    with BaseState<Exception, List<FindCommunityMemberOutput>>
    implements CommunityDetailsController {
  DefaultCommunityDetailsController({
    required CommunityRepository communityRepository,
  }) : _communityRepository = communityRepository;
  final CommunityRepository _communityRepository;

  @override
  Future<void> getMembers({required String id}) async {
    state.set(LoadingState());
    final membersOrError = await _communityRepository.getCommunityMembers(id);
    stateFromEither(membersOrError);
  }
}
