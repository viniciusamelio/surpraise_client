import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../../contexts/auth/auth.dart';
import '../../../contexts/feed/feed.dart';
import '../../../core/core.dart';

import '../../../core/external_dependencies.dart';
import '../../shared.dart';

abstract class SessionController {
  AtomNotifier<UserDto?> get currentUser;

  Future<void> logout();
  Future<void> updateUser(UserDto input);
  Future<void> setLastInteractedCommunity(CommunityOutput input);
}

class DefaultSessionController implements SessionController {
  DefaultSessionController({
    required this.authService,
    required this.authPersistanceService,
  });

  final AuthService authService;
  final AuthPersistanceService authPersistanceService;

  @override
  final AtomNotifier<UserDto?> currentUser = AtomNotifier(null);

  @override
  Future<void> logout() async {
    await authService.logout();
    injected<FeedController>().state.set(InitialState());
    await authPersistanceService.deleteAuthenticatedUserData();
    currentUser.set(null);
    Navigator.of(navigatorKey.currentContext!).pushReplacementNamed(
      LoginScreen.routeName,
    );
    OneSignal.logout();
  }

  @override
  Future<void> updateUser(UserDto input) async {
    await authPersistanceService.saveAuthenticatedUserData(input);
    currentUser.set(input);
  }

  @override
  Future<void> setLastInteractedCommunity(CommunityOutput input) async {
    if (currentUser.value != null) {
      await updateUser(
        currentUser.value!.copyWith(
          lastInteractedCommunity: input,
        ),
      );
    }
  }
}
