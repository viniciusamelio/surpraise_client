import 'package:flutter/material.dart';
import '../../../contexts/auth/auth.dart';
import '../../../core/core.dart';

import '../../shared.dart';

abstract class SessionController {
  late UserDto? currentUser;

  Future<void> logout();
}

class DefaultSessionController implements SessionController {
  DefaultSessionController({
    required this.authService,
    required this.authPersistanceService,
  });

  final AuthService authService;
  final AuthPersistanceService authPersistanceService;

  @override
  UserDto? currentUser;

  @override
  Future<void> logout() async {
    await authService.logout();
    await authPersistanceService.deleteAuthenticatedUserData();
    Navigator.of(navigatorKey.currentContext!).pushReplacementNamed(
      LoginScreen.routeName,
    );
  }
}
