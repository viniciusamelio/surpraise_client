import 'package:atom_notifier/notifier.dart';

import '../../../../core/state/base_state_controller.dart';
import '../../../../core/state/default_state.dart';
import '../../dtos/edit_profile.dart';

abstract class EditProfileController extends BaseStateController<void> {
  Future<void> update(EditProfileDto input);
}

class DefaultEditProfileController implements EditProfileController {
  @override
  final AtomNotifier<DefaultState<Exception, void>> state =
      AtomNotifier(InitialState());

  @override
  Future<void> update(EditProfileDto input) async {
    // TODO: implement update
  }
}
