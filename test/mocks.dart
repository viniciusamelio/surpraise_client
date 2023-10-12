import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_client/contexts/auth/application/application.dart';
import 'package:surpraise_client/contexts/community/community.dart';
import 'package:surpraise_client/contexts/feed/feed.dart';
import 'package:surpraise_client/core/core.dart';
import 'package:surpraise_client/core/external_dependencies.dart'
    hide CommunityRepository;
import 'package:surpraise_client/shared/shared.dart';

class MockSessionController extends Mock implements SessionController {
  final AtomNotifier<UserDto?> _userNotifier = AtomNotifier(
    UserDto(
      id: faker.guid.guid(),
      name: faker.person.name(),
      email: faker.internet.email(),
      tag: "@fake",
      avatarUrl: faker.internet.httpsUrl(),
    ),
  );

  @override
  Future<void> updateUser(UserDto input) async {
    _userNotifier.set(input);
  }

  @override
  AtomNotifier<UserDto?> get currentUser => _userNotifier;
}

class MockCommunityRepository extends Mock implements CommunityRepository {}

class MockImageManager extends Mock implements ImageManager {}

class MockImageController extends Mock implements ImageController {}

class MockPraiseUsecase extends Mock implements PraiseUsecase {}

class MockAnswerInviteController extends Mock
    implements AnswerInviteController {}

class MockFeedRepository extends Mock implements FeedRepository {}

class MockLinkHandler extends Mock implements LinkHandler {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockGetNotificationsRepository extends Mock
    implements GetNotificationsRepository {}

class MockReadNotificationsRepository extends Mock
    implements ReadNotificationsRepository {}

class MockSupabaseClient extends Mock implements RealtimeQuery {}

class MockAuthService extends Mock implements AuthService {}

class MockCommunitiesByUserQuery extends Mock
    implements GetCommunitiesByUserQuery {}

class MockGetUserByTagQuery extends Mock implements GetUserByTagQuery {}

class MockLeaveCommunityUsecase extends Mock implements LeaveCommunityUsecase {}

class MockGetMembersQuery extends Mock implements GetMembersQuery {}
