import '../../core/core.dart';
import '../../core/external_dependencies.dart' as core show CommunityRepository;
import '../feed/feed.dart';
import 'community.dart';
import 'presentation/controllers/remove_member.dart';

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
      sessionController: injected(),
    ),
  );
  inject<InviteController>(
    DefaultInviteController(
      inviteRepository: injected(),
      communityRepository: injected(),
    ),
    singleton: false,
  );
  inject<AnswerInviteController>(
    DefaultAnswerInviteController(
      inviteRepository: injected(),
      sessionController: injected(),
    ),
  );
  inject<core.CommunityRepository>(
    core.CommunityRepository(
      databaseDatasource: injected(),
    ),
  );
  inject<RemoveMembersUsecase>(
    DbRemoveMembersUsecase(
      removeMembersRepository: injected<core.CommunityRepository>(),
      findCommunityRepository: injected<core.CommunityRepository>(),
    ),
  );
  inject<RemoveMemberController>(
    DefaultRemoveMemberController(
      removeMembersUsecase: injected(),
    ),
  );
}
