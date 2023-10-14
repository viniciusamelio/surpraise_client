import 'package:flutter/material.dart';
import '../../../../env.dart';
import '../../../auth/auth.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../main/main_screen.dart';

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
    state.set(LoadingState());
    final persistedUser = await authPersistanceService.getAuthenticatedUser();
    if (persistedUser == null) {
      Navigator.of(navigatorKey.currentContext!).pushReplacementNamed(
        LoginScreen.routeName,
      );
      return;
    }
    final avatar = await storageService.getImage(
      bucketId: Env.avatarBucket,
      fileId: persistedUser.id,
    );
    Navigator.of(navigatorKey.currentContext!).pushReplacementNamed(
      MainScreen.routeName,
      arguments: persistedUser.copyWith(
        avatarUrl: avatar.fold(
          (left) => null,
          (right) => right,
        ),
      ),
    );
  }
}
