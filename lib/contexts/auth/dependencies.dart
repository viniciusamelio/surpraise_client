import '../../core/core.dart';
import '../../shared/shared.dart';
import 'auth.dart';
import 'presentation/controllers/controllers.dart';

Future<void> authDependencies() async {
  inject<AuthService>(
    DefaultAuthService(
      appWriteAuthService: injected(),
      httpClient: injected(),
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
    ),
  );
  inject<SignInController>(
    DefaultSignInController(
      authService: injected(),
      authPersistanceService: injected(),
    ),
  );
}
