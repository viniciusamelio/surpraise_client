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
  })  : _authService = authService,
        _authPersistanceService = authPersistanceService {
    setDefaultErrorHandling();
    state.listenState(
      onSuccess: (right) async {
        final dto = UserDto(
          tag: right.tag,
          name: right.name,
          email: right.email,
          id: right.id,
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
