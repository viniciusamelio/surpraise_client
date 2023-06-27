import 'package:surpraise_infra/surpraise_infra.dart';

import '../../../../core/core.dart';
import '../../application/application.dart';
import '../../dtos/dtos.dart';

abstract class SignInController extends BaseStateController<GetUserOutput> {
  SignInFormDataDto get formData;
  Future<void> signIn();

  void dispose();
}

class DefaultSignInController
    with BaseState<Exception, GetUserOutput>
    implements SignInController {
  DefaultSignInController({
    required AuthService authService,
  }) : _authService = authService;

  final AuthService _authService;

  @override
  final SignInFormDataDto formData = SignInFormDataDto();

  @override
  void dispose() {
    state.dispose();
  }

  @override
  Future<void> signIn() async {
    state.value = LoadingState();
    final result = await _authService.signinStepOne(formData);
    result.fold(
      (left) => state.value = ErrorState(left),
      (right) async {
        final result = await _authService.signinStepTwo(right);
        stateFromEither(result);
      },
    );
  }
}
