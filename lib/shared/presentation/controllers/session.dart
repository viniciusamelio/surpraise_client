import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../contexts/auth/auth.dart';
import '../../../core/core.dart';

import '../../../core/external_dependencies.dart';
import '../../shared.dart';

abstract class SessionController {
  AtomNotifier<UserDto?> get currentUser;

  Future<void> logout();

  Future<void> updateUser(UserDto input);
}

class DefaultSessionController implements SessionController {
  DefaultSessionController({
    required this.authService,
    required this.authPersistanceService,
  }) {
    injected<Box>().listenable(keys: ["user"]).addListener(() async {
      final user = await authPersistanceService.getAuthenticatedUser();
      currentUser.set(user);
    });
  }

  final AuthService authService;
  final AuthPersistanceService authPersistanceService;

  @override
  final AtomNotifier<UserDto?> currentUser = AtomNotifier(null);

  @override
  Future<void> logout() async {
    await authService.logout();
    await authPersistanceService.deleteAuthenticatedUserData();
    Navigator.of(navigatorKey.currentContext!).pushReplacementNamed(
      LoginScreen.routeName,
    );
  }

  @override
  Future<void> updateUser(UserDto input) async {
    await authPersistanceService.saveAuthenticatedUserData(input);
    currentUser.set(input);
  }
}
