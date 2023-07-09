import 'package:flutter/material.dart';
import '../../../auth/auth.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../feed/presentation/presentation.dart';

abstract class IntroController extends BaseStateController<bool> {
  Future<void> handleFirstPage();
}

class DefaultIntroController
    with BaseState<Exception, bool>
    implements IntroController {
  DefaultIntroController({
    required this.authPersistanceService,
    required this.storageService,
    required this.authService,
  });

  final AuthPersistanceService authPersistanceService;
  final StorageService storageService;
  final AuthService authService;

  @override
  Future<void> handleFirstPage() async {
    state.value = LoadingState();
    final persistedUser = await authPersistanceService.getAuthenticatedUser();
    if (persistedUser == null) {
      Navigator.of(navigatorKey.currentContext!).pushReplacementNamed(
        LoginScreen.routeName,
      );
      return;
    }
    final formData = SignInFormDataDto();
    formData.password = persistedUser.password!;
    formData.username = persistedUser.email;
    await authService.signinStepOne(formData);
    final avatar = await storageService.getImage(
      bucketId: "64aa003bb7d50755c815",
      fileId: persistedUser.id,
    );
    Navigator.of(navigatorKey.currentContext!).pushReplacementNamed(
      FeedScreen.routeName,
      arguments: persistedUser.copyWith(
        avatar: avatar.fold(
          (left) => null,
          (right) => right,
        ),
      ),
    );
  }
}
