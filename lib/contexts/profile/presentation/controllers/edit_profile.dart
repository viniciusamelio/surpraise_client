import '../../../../core/core.dart';
import '../../profile.dart';

abstract class EditProfileController extends BaseStateController<void> {
  Future<void> update(EditUserInput input);
}

class DefaultEditProfileController
    with BaseState<Exception, void>
    implements EditProfileController {
  DefaultEditProfileController({
    required EditUserRepository userRepository,
  }) : _userRepository = userRepository {
    setDefaultErrorHandling();
  }
  final EditUserRepository _userRepository;

  @override
  Future<void> update(EditUserInput input) async {
    state.set(LoadingState());
    final editedUserOrError = await _userRepository.edit(input);
    stateFromEither(editedUserOrError);
    editedUserOrError.fold((left) => null, (right) {
      injected<ApplicationEventBus>().add(ProfileEditedEvent(right));
    });
  }
}
