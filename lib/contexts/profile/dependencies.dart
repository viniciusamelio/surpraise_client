import '../../core/core.dart';
import '../../core/external_dependencies.dart';
import 'presentation/controllers/controllers.dart';

Future<void> profileDependencies() async {
  inject<EditUserRepository>(
    UserRepository(
      databaseDatasource: injected(),
    ),
  );
  inject<ProfileController>(
    DefaultProfileController(
      feedRepository: injected(),
      imageController: injected(),
      storageService: injected(),
      communitiesByUserQuery: injected(),
    ),
  );

  inject<EditProfileController>(
    DefaultEditProfileController(
      userRepository: injected(),
    ),
  );
}
