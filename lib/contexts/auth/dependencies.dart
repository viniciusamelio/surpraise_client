import 'presentation/controllers/controllers.dart';

import '../../core/core.dart';
import 'auth.dart';

Future<void> authDependencies() async {
  inject<AuthService>(
    DefaultAuthService(
      appWriteAuthService: injected(),
      httpClient: injected(),
    ),
  );
  inject<SignupController>(
    DefaultSignupController(
      authService: injected(),
    ),
  );
}
