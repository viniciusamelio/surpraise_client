import 'package:flutter/material.dart';

import '../../shared/presentation/controllers/session.dart';
import '../di/di.dart';
import '../external_dependencies.dart';

mixin SupabaseGuardRoute<T extends StatefulWidget> on State<T> {
  final sessionController = injected<SessionController>();

  Future<void> checkSession() async {
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;
    if (session == null) {
      sessionController.logout();
      return;
    }

    if (session.isExpired) {
      final newSession = await supabase.auth.refreshSession();
      if (newSession.session!.isExpired) {
        sessionController.logout();
        return;
      }
    }
  }
}
