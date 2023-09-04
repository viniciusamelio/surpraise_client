import '../../core/core.dart';
import 'community.dart';

Future<void> communityDependencies() async {
  inject<CommunityRepository>(
    DefaultCommunityRepository(
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
}
