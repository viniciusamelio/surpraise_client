import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../env.dart';
import '../../../../shared/shared.dart';
import '../../../main/main_screen.dart';
import '../../auth.dart';

abstract class SignupController extends BaseStateController<CreateUserOutput> {
  SignupFormDataDto get formData;
  Future<void> signup({required bool isSocial});

  void setFormData(SignupFormDataDto formData);

  ValueNotifier<File?> get profilePicture;
}

class DefaultSignupController
    with BaseState<Exception, CreateUserOutput>
    implements SignupController {
  DefaultSignupController({
    required this.authService,
    required this.authPersistanceService,
    required this.storageService,
    required this.createUserRepository,
  }) {
    state.listenState(
      onError: (left) {
        const ErrorSnack(message: "Deu ruim ao criar sua conta")
            .show(context: context);
      },
    );
  }

  final AuthService authService;
  final AuthPersistanceService authPersistanceService;
  final StorageService storageService;
  final CreateUserRepository createUserRepository;

  @override
  SignupFormDataDto formData = SignupFormDataDto();

  @override
  Future<void> signup({
    required bool isSocial,
  }) async {
    state.set(LoadingState());

    final result = !isSocial
        ? await authService.signup(
            SignupCredentialsDto(
              tag: "@${formData.tag}",
              email: formData.email!,
              password: formData.password,
              name: formData.name!,
            ),
          )
        : await createUserRepository.create(
            CreateUserInput(
              tag: "@${formData.tag}",
              name: formData.name!,
              email: formData.email!,
              id: injected<SupabaseCloudClient>().supabase.auth.currentUser!.id,
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

  @override
  void setFormData(SignupFormDataDto formData) {
    this.formData = formData;
  }
}
