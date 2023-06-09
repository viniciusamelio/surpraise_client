import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../feed/presentation/presentation.dart';
import '../../auth.dart';

abstract class SignupController extends BaseStateController<SignupStatus> {
  SignupFormDataDto get formData;
  Future<void> signup();
}

class DefaultSignupController
    with BaseState<Exception, SignupStatus>
    implements SignupController {
  DefaultSignupController({
    required this.authService,
    required this.authPersistanceService,
  }) {
    state.listenState(
      onSuccess: (right) {
        Navigator.of(navigatorKey.currentContext!).pushReplacementNamed(
          FeedScreen.routeName,
        );
      },
    );
    setDefaultErrorHandling();
  }

  final AuthService authService;
  final AuthPersistanceService authPersistanceService;

  @override
  final SignupFormDataDto formData = SignupFormDataDto();

  @override
  Future<void> signup() async {
    state.value = LoadingState();
    final input = CreateUserInput(
      tag: "@${formData.tag}",
      name: formData.name,
      email: formData.email,
    );
    final stepOneResult = await authService.signupStepOne(input);
    stepOneResult.fold(
      (left) => state.value = ErrorState(left),
      (right) async {
        final result = await authService.signupStepTwo(
          SignupCredentialsDto(
            id: right.id,
            tag: right.tag,
            email: right.email,
            password: formData.password,
          ),
        );
        result.fold(
          (__) => null,
          (_) async {
            await authPersistanceService.saveAuthenticatedUserData(
              UserDto(
                tag: right.tag,
                name: right.name,
                email: right.email,
                id: right.id,
              ),
            );
          },
        );
        stateFromEither(result);
      },
    );
  }
}
