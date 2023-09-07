import '../../../../core/core.dart';
import '../../community.dart';
import '../../dtos/dtos.dart';

abstract class GetCommunitiesController
    extends BaseStateController<List<ListUserCommunitiesOutput>> {
  Future<void> getCommunities(String userId);
}

class DefaultGetCommunitiesController
    with BaseState<Exception, List<ListUserCommunitiesOutput>>
    implements GetCommunitiesController {
  DefaultGetCommunitiesController({
    required CommunityRepository communityRepository,
  }) : _communityRepository = communityRepository;

  final CommunityRepository _communityRepository;
  @override
  Future<void> getCommunities(String userId) async {
    state.set(LoadingState());
    final communitiesOrError =
        await _communityRepository.getCommunities(userId);
    stateFromEither(communitiesOrError);
  }
}
