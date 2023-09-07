import 'package:flutter/material.dart';
import '../../../community/application/application.dart';

import '../../../../core/core.dart';
import '../../../../shared/dtos/dtos.dart';
import '../../../community/dtos/dtos.dart';
import '../../../feed/application/application.dart';

typedef Communities = List<ListUserCommunitiesOutput>;
typedef Praises = List<PraiseDto>;

abstract class ProfileController extends BaseStateController<Praises> {
  ValueNotifier<DefaultState<Exception, Communities>> get communitiesState;

  Future<void> getCommunities(String userId);
  Future<void> getPraises(String userId);
}

class DefaultProfileController
    with BaseState<Exception, Praises>
    implements ProfileController {
  DefaultProfileController({
    required CommunityRepository communityRepository,
    required FeedRepository feedRepository,
  })  : _feedRepository = feedRepository,
        _communityRepository = communityRepository;

  final FeedRepository _feedRepository;
  final CommunityRepository _communityRepository;
  @override
  final ValueNotifier<DefaultState<Exception, Communities>> communitiesState =
      ValueNotifier(InitialState());

  @override
  Future<void> getCommunities(String userId) async {
    communitiesState.value = LoadingState();
    final communitiesOrError =
        await _communityRepository.getCommunities(userId);
    communitiesState.value = communitiesOrError.fold(
      (left) => ErrorState(left),
      (right) => SuccessState(right),
    );
  }

  @override
  Future<void> getPraises(String userId) async {
    state.value = LoadingState();
    final feedsOrError =
        await _feedRepository.getByUser(userId: userId, asPraiser: false);
    stateFromEither(feedsOrError);
  }
}
