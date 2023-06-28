import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../auth/presentation/screens/login.dart';
import '../../../feed/presentation/presentation.dart';

abstract class IntroController extends BaseStateController<bool> {
  Future<void> handleFirstPage();
}

class DefaultIntroController
    with BaseState<Exception, bool>
    implements IntroController {
  DefaultIntroController({required this.authPersistanceService});

  final AuthPersistanceService authPersistanceService;

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
    Navigator.of(navigatorKey.currentContext!).pushReplacementNamed(
      FeedScreen.routeName,
      arguments: persistedUser,
    );
  }
}
