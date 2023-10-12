import '../../core/core.dart';
import '../../core/external_dependencies.dart';
import '../feed/feed.dart';
import 'community.dart';
import 'presentation/controllers/remove_member.dart';

Future<void> communityDependencies() async {
  inject<CommunityRepository>(
    CommunityRepository(
      databaseDatasource: injected(),
    ),
  );
  inject<CreateCommunityUsecase>(
    DbCreateCommunityUsecase(
      createCommunityRepository: injected<CommunityRepository>(),
      idService: injected(),
    ),
  );
  inject<UpdateCommunityUsecase>(
    DbUpdateCommunityUsecase(
      updateCommunityRepository: injected<CommunityRepository>(),
    ),
  );
  inject<InviteRepository>(
    DefaultInviteRepository(
      databaseDatasource: injected(),
    ),
  );
  inject<GetMembersQuery>(
    GetMembersQuery(
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
      sessionController: injected(),
      imageManager: injected(),
      imageController: injected(),
      createCommunityUsecase: injected(),
      updateCommunityUsecase: injected(),
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

  inject<RemoveMembersUsecase>(
    DbRemoveMembersUsecase(
      removeMembersRepository: injected<CommunityRepository>(),
      findCommunityRepository: injected<CommunityRepository>(),
    ),
  );
  inject<RemoveMemberController>(
    DefaultRemoveMemberController(
      removeMembersUsecase: injected(),
    ),
  );
  inject<CommunityDetailsController>(
    DefaultCommunityDetailsController(
      getMembersQuery: injected(),
      sessionController: injected(),
      leaveCommunityUsecase: DbLeaveCommunityUsecase(
        leaveCommunityRepository: injected<CommunityRepository>(),
      ),
    ),
  );
}
