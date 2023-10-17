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
    required this.rootDetector,
  });

  final AuthPersistanceService authPersistanceService;
  final StorageService storageService;
  final AuthService authService;
  final RootDetector rootDetector;

  @override
  Future<void> handleFirstPage() async {
    state.set(LoadingState());
    final rootedDeviceOrError = await rootDetector.check();
    if (rootedDeviceOrError.isRight() &&
        rootedDeviceOrError.fold((left) => null, (right) => right)! == true) {
      state.set(
        ErrorState(
          ApplicationException(
            message:
                "Dispositivo rooteado detectado, por favor, rode o aplicativo num ambiente seguro",
          ),
        ),
      );
      return;
    }
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
