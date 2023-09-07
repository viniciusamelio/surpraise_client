import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../env.dart';
import '../../../../shared/shared.dart';
import '../../../main/main_screen.dart';
import '../../auth.dart';

abstract class SignupController extends BaseStateController<CreateUserOutput> {
  SignupFormDataDto get formData;
  Future<void> signup();

  ValueNotifier<File?> get profilePicture;
}

class DefaultSignupController
    with BaseState<Exception, CreateUserOutput>
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
    state.set(LoadingState());

    final result = await authService.signup(
      SignupCredentialsDto(
        tag: "@${formData.tag}",
        email: formData.email,
        password: formData.password,
        name: formData.name,
      ),
    );
    result.fold(
      (left) => state.set(ErrorState(left)),
      (right) async {
        final uploadedImage = await storageService.uploadImage(
          StorageImageDto(
            bucketId: Env.avatarBucket,
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
          avatarUrl: uploadedImage.fold(
            (left) => null,
            (right) => right,
          ),
        );
        await authPersistanceService.saveAuthenticatedUserData(
          user,
        );
        Navigator.of(navigatorKey.currentContext!).pushReplacementNamed(
          MainScreen.routeName,
          arguments: user,
        );
      },
    );
    stateFromEither(result);
  }

  @override
  final ValueNotifier<File?> profilePicture = ValueNotifier(null);
}
