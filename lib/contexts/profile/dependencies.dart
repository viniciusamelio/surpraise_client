import '../../core/core.dart';
import 'presentation/controllers/controllers.dart';

Future<void> profileDependencies() async {
  inject<ProfileController>(
    DefaultProfileController(
      communityRepository: injected(),
      feedRepository: injected(),
    ),
  );
  inject<EditProfileController>(
    DefaultEditProfileController(),
  );
}
