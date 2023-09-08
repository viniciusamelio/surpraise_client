import '../../core/core.dart';
import 'community.dart';

Future<void> communityDependencies() async {
  inject<CommunityRepository>(
    DefaultCommunityRepository(
      databaseDatasource: injected(),
    ),
  );
  inject<InviteRepository>(
    DefaultInviteRepository(
      databaseDatasource: injected(),
    ),
  );
  inject<GetCommunitiesController>(
    DefaultGetCommunitiesController(
      communityRepository: injected(),
    ),
  );
  inject<NewCommunityController>(
    DefaultNewCommunityController(
      communityRepository: injected(),
      sessionController: injected(),
      imageManager: injected(),
      imageController: injected(),
    ),
    singleton: false,
  );
  inject<CommunityDetailsController>(
    DefaultCommunityDetailsController(
      communityRepository: injected(),
    ),
  );
  inject<InviteController>(
    DefaultInviteController(
      inviteRepository: injected(),
      communityRepository: injected(),
    ),
    singleton: false,
  );
}
