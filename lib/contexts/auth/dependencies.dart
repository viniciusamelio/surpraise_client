import '../../core/core.dart';
import '../../shared/shared.dart';
import 'auth.dart';
import 'presentation/controllers/controllers.dart';

Future<void> authDependencies() async {
  inject<AuthService>(
    DefaultAuthService(
      supabaseClient: injected(),
      databaseDatasource: injected(),
    ),
  );
  inject<AuthPersistanceService>(
    ScientistAuthPersistanceService(
      database: injected(),
    ),
  );
  inject<SignupController>(
    DefaultSignupController(
      authService: injected(),
      authPersistanceService: injected(),
      storageService: injected(),
    ),
  );
  inject<SignInController>(
    DefaultSignInController(
      authService: injected(),
      authPersistanceService: injected(),
      storageService: injected(),
    ),
  );
  inject<SessionController>(
    DefaultSessionController(
      authService: injected(),
      authPersistanceService: injected(),
    ),
    singleton: true,
  );
}
