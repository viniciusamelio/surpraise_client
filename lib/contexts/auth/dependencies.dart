import '../../core/core.dart';
import '../../core/external_dependencies.dart';
import '../../shared/shared.dart';
import 'auth.dart';
import 'presentation/controllers/controllers.dart';

Future<void> authDependencies() async {
  inject<UserRepository>(
    UserRepository(
      databaseDatasource: injected(),
    ),
  );
  inject<GetUserQuery>(
    GetUserQuery(
      databaseDatasource: injected(),
    ),
  );
  inject<AuthService>(
    DefaultAuthService(
      supabaseClient: injected(),
      httpClient: injected(),
      createUserRepository: injected<UserRepository>(),
      getUserQuery: injected(),
    ),
  );
  inject<AuthPersistanceService>(
    HiveAuthPersistanceService(
      hiveBox: injected(),
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
  inject<PasswordRecoveryController>(
    DefaultPasswordController(
      authService: injected(),
    ),
  );
}
