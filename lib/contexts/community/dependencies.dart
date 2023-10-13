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

  inject<InvitationRepository>(
    InvitationRepository(
      databaseDatasource: injected(),
    ),
  );
  inject<InviteMemberUsecase>(
    DbInviteMemberUsecase(
      inviteMemberRepository: injected<InvitationRepository>(),
      findCommunityRepository: injected<CommunityRepository>(),
      idService: injected(),
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
      inviteMemberUsecase: injected(),
      getUserByTagQuery: injected(),
    ),
    singleton: false,
  );
  inject<AnswerInviteUsecase>(
    DbAnswerInviteUsecase(
      answerInviteRepository: injected<InvitationRepository>(),
    ),
  );
  inject<AnswerInviteController>(
    DefaultAnswerInviteController(
      answerInviteUsecase: injected(),
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
