import '../../core/core.dart';
import '../../core/external_dependencies.dart';
import 'presentation/controllers/controllers.dart';

Future<void> profileDependencies() async {
  inject<ProfileController>(
    DefaultProfileController(
      communityRepository: injected(),
      feedRepository: injected(),
    ),
  );
  inject<EditUserRepository>(
    UserRepository(
      databaseDatasource: injected(),
    ),
  );
  inject<EditProfileController>(
    DefaultEditProfileController(
      userRepository: injected(),
    ),
  );
}
