import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_client/contexts/community/community.dart';
import 'package:surpraise_client/contexts/feed/feed.dart';
import 'package:surpraise_client/core/core.dart';
import 'package:surpraise_client/core/external_dependencies.dart'
    hide CommunityRepository;
import 'package:surpraise_client/shared/shared.dart';

class MockSessionController extends Mock implements SessionController {
  @override
  AtomNotifier<UserDto?> get currentUser => AtomNotifier(
        UserDto(
          id: faker.guid.guid(),
          name: faker.person.name(),
          email: faker.internet.email(),
          tag: "@fake",
          avatarUrl: faker.internet.httpsUrl(),
        ),
      );
}

class MockCommunityRepository extends Mock implements CommunityRepository {}

class MockImageManager extends Mock implements ImageManager {}

class MockImageController extends Mock implements ImageController {}

class MockPraiseUsecase extends Mock implements PraiseUsecase {}

class MockAnswerInviteController extends Mock
    implements AnswerInviteController {}

class MockFeedRepository extends Mock implements FeedRepository {}
