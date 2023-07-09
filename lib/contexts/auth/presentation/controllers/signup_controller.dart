import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../feed/presentation/presentation.dart';
import '../../auth.dart';

abstract class SignupController extends BaseStateController<SignupStatus> {
  SignupFormDataDto get formData;
  Future<void> signup();

  ValueNotifier<File?> get profilePicture;
}

class DefaultSignupController
    with BaseState<Exception, SignupStatus>
    implements SignupController {
  DefaultSignupController({
    required this.authService,
    required this.authPersistanceService,
    required this.storageService,
  }) {
    setDefaultErrorHandling();
  }

  final AuthService authService;
  final AuthPersistanceService authPersistanceService;
  final StorageService storageService;

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
          (left) => state.value = ErrorState(left),
          (_) async {
            await storageService.uploadImage(
              StorageImageDto(
                bucketId: "64aa003bb7d50755c815",
                file: profilePicture.value!,
                id: right.id,
              ),
            );
            final user = UserDto(
              tag: right.tag,
              name: right.name,
              password: formData.password,
              email: right.email,
              id: right.id,
              avatar: profilePicture.value,
            );
            await authPersistanceService.saveAuthenticatedUserData(
              user,
            );
            Navigator.of(navigatorKey.currentContext!).pushReplacementNamed(
              FeedScreen.routeName,
              arguments: user,
            );
          },
        );
        stateFromEither(result);
      },
    );
  }

  @override
  final ValueNotifier<File?> profilePicture = ValueNotifier(null);
}
