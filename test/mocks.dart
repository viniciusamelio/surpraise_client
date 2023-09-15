import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_client/contexts/community/community.dart';
import 'package:surpraise_client/core/core.dart';
import 'package:surpraise_client/shared/shared.dart';

class MockSessionController extends Mock implements SessionController {
  @override
  UserDto? get currentUser => UserDto(
        id: faker.guid.guid(),
        name: faker.person.name(),
        email: faker.internet.email(),
        tag: "@fake",
      );
}

class MockCommunityRepository extends Mock implements CommunityRepository {}

class MockImageManager extends Mock implements ImageManager {}

class MockImageController extends Mock implements ImageController {}
