import 'package:flutter/material.dart';
import '../../../../shared/shared.dart';
import 'package:surpraise_infra/surpraise_infra.dart';

import '../../../../core/core.dart';
import '../../../../env.dart';
import '../../../main/main_screen.dart';
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
    state.listenState(
      onSuccess: (right) async {
        final avatar = await _storageService.getImage(
          bucketId: Env.avatarBucket,
          fileId: right.id,
        );
        final dto = UserDto(
          tag: right.tag,
          name: right.name,
          email: right.email,
          password: formData.password,
          id: right.id,
          avatarUrl: avatar.fold(
            (left) => null,
            (right) => right,
          ),
        );
        await _authPersistanceService.saveAuthenticatedUserData(dto);
        Navigator.of(navigatorKey.currentContext!).pushReplacementNamed(
          MainScreen.routeName,
          arguments: dto,
        );
      },
      onError: (left) {
        const ErrorSnack(message: "Deu ruim ao te logar")
            .show(context: context);
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
    state.set(LoadingState());
    final result = await _authService.signin(formData);
    stateFromEither(result);
  }
}
