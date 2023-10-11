import '../../core/core.dart';
import '../../core/external_dependencies.dart' as core show CommunityRepository;
import '../../core/external_dependencies.dart' hide CommunityRepository;
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
  inject<GetCommunitiesByUserQuery>(
    GetCommunitiesByUserQuery(
      databaseDatasource: injected(),
    ),
  );
  inject<GetUserByTagQuery>(
    GetUserByTagQuery(
      databaseDatasource: injected(),
    ),
  );
  inject<GetCommunitiesController>(
    DefaultGetCommunitiesController(
      getCommunitiesByUserQuery: injected(),
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

  inject<InviteController>(
    DefaultInviteController(
      inviteRepository: injected(),
      getUserByTagQuery: injected(),
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
  inject<CommunityDetailsController>(
    DefaultCommunityDetailsController(
      communityRepository: injected(),
      sessionController: injected(),
      leaveCommunityUsecase: DbLeaveCommunityUsecase(
        leaveCommunityRepository: injected<core.CommunityRepository>(),
      ),
    ),
  );
}
