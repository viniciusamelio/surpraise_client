import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../auth.dart';

mixin SocialAuthWidget<T extends StatefulWidget> on State<T> {
  late final StreamSubscription<AuthState> oauthSubscription;

  void disposeSocialAuth() {
    oauthSubscription.cancel();
  }

  void listenToSocialAuth() async {
    final eventBus = injected<ApplicationEventBus>();
    oauthSubscription = injected<SupabaseCloudClient>()
        .supabase
        .auth
        .onAuthStateChange
        .listen((event) {
      if (event.event == AuthChangeEvent.signedIn) {
        final session = event.session;
        final provider = session?.user.appMetadata["provider"];

        if (session != null &&
            (["discord", "github"].contains(provider) ||
                session.user.userMetadata?["iss"] ==
                    "https://api.github.com")) {
          eventBus.add(
            SocialSignedInEvent(
              SocialAuthDetailsDto(
                id: session.user.id,
                email: session.user.email!,
                name: session.user.userMetadata?["custom_claims"]
                        ?["global_name"] ??
                    session.user.userMetadata!["full_name"],
                provider: provider == "discord"
                    ? SocialProvider.discord
                    : SocialProvider.github,
              ),
            ),
          );
        }
      }
    });
  }
}
