import '../../../../core/core.dart';
import '../../community.dart';

abstract class GetCommunitiesController
    extends BaseStateController<List<FindCommunityOutput>> {
  Future<void> getCommunities(String userId);
}

class DefaultGetCommunitiesController
    with BaseState<Exception, List<FindCommunityOutput>>
    implements GetCommunitiesController {
  DefaultGetCommunitiesController({
    required CommunityRepository communityRepository,
  }) : _communityRepository = communityRepository;

  final CommunityRepository _communityRepository;
  @override
  Future<void> getCommunities(String userId) async {
    state.value = LoadingState();
    final communitiesOrError =
        await _communityRepository.getCommunities(userId);
    stateFromEither(communitiesOrError);
  }
}
