import 'package:flutter/material.dart';
import 'package:surpraise_client/contexts/feed/presentation/presentation.dart';
import 'package:surpraise_client/shared/shared.dart';
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
    required AuthPersistanceService authPersistanceService,
    required StorageService storageService,
  })  : _authService = authService,
        _storageService = storageService,
        _authPersistanceService = authPersistanceService {
    setDefaultErrorHandling();
    state.listenState(
      onSuccess: (right) async {
        final avatar = await _storageService.getImage(
          bucketId: "64aa003bb7d50755c815",
          fileId: right.id,
        );
        final dto = UserDto(
          tag: right.tag,
          name: right.name,
          email: right.email,
          password: formData.password,
          id: right.id,
          avatar: avatar.fold((left) => null, (right) => right),
        );
        await _authPersistanceService.saveAuthenticatedUserData(dto);
        Navigator.of(navigatorKey.currentContext!).pushReplacementNamed(
          FeedScreen.routeName,
          arguments: dto,
        );
      },
    );
  }

  final AuthService _authService;
  final AuthPersistanceService _authPersistanceService;
  final StorageService _storageService;

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
