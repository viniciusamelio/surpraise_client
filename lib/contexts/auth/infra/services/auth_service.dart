import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../auth.dart';

class DefaultAuthService implements AuthService {
  DefaultAuthService({
    required SupabaseCloudClient supabaseClient,
    required CreateUserRepository createUserRepository,
    required GetUserQuery getUserQuery,
  })  : _supabase = supabaseClient,
        _userQuery = getUserQuery,
        _createUserRepository = createUserRepository;

  final SupabaseCloudClient _supabase;
  final CreateUserRepository _createUserRepository;
  final GetUserQuery _userQuery;

  @override
  AsyncAction<GetUserOutput> signin(SignInFormDataDto input) async {
    try {
      final user = await _supabase.signIn(
        email: input.username,
        password: input.password,
      );
      final userOrError = await _userQuery(
        GetUserQueryInput(
          id: user.id,
        ),
      );

      if (userOrError.isLeft()) {
        return Left(InvalidCredentialsException());
      }

      final response = userOrError.fold(
        (left) => null,
        (right) => right.value,
      )!;
      return Right(
        GetUserOutput(
          tag: response.tag,
          name: response.name,
          email: response.email,
          id: user.id,
        ),
      );
    } on Exception catch (_) {
      return Left(
        InvalidCredentialsException(),
      );
    }
  }

  @override
  AsyncAction<void> logout() async {
    await _supabase.logout();
    return Right(null);
  }

  @override
  AsyncAction<CreateUserOutput> signup(SignupCredentialsDto input) async {
    try {
      final user = await _supabase.signUp(
        email: input.email,
        password: input.password,
      );

      final response = await _createUserRepository.create(
        CreateUserInput(
          tag: input.tag,
          name: input.name,
          email: input.email,
          id: user.id,
        ),
      );
      if (response.isLeft()) {
        return Left(Exception("Something went wrong signing you up"));
      }

      final createdUser = response.fold(
        (left) => null,
        (right) => right,
      )!;

      return Right(
        CreateUserOutput(
          tag: createdUser.tag,
          name: createdUser.name,
          email: createdUser.email,
          id: createdUser.id,
        ),
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  AsyncAction<void> deleteAccount(String userId) async {
    try {
      await _supabase.supabase.functions.invoke(
        "account-manager",
        body: {
          "userId": userId,
        },
      );
      return Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  AsyncAction<void> confirmRecoveryCode({
    required String code,
    required String email,
  }) async {
    try {
      await _supabase.checkResetOtp(token: code, email: email);
      return Right(null);
    } catch (_) {
      return Left(Exception("Invalid code"));
    }
  }

  @override
  AsyncAction<void> confirmPasswordReset(String password) async {
    try {
      await _supabase.changePassword(newPassword: password);
      return Right(null);
    } catch (e) {
      return Left(Exception("Something went wrong resetting your password"));
    }
  }

  @override
  AsyncAction<void> requestPasswordReset(String email) async {
    try {
      await _supabase.requestPasswordReset(email: email);
      return Right(null);
    } catch (e) {
      return Left(
        Exception(
          "Something went wrong request your password reset",
        ),
      );
    }
  }

  @override
  AsyncAction<void> socialLogin(SocialProvider provider) async {
    try {
      final success = await _supabase.supabase.auth.signInWithOAuth(
        Provider.values.singleWhere((element) => provider.name == element.name),
        redirectTo: "surpraise://app/auth/callback",
        authScreenLaunchMode: LaunchMode.platformDefault,
        context: navigatorKey.currentContext!,
      );
      if (!success) throw Exception("Login Error");
      return Right(null);
    } on Exception catch (_) {
      return Left(
        InvalidCredentialsException(),
      );
    }
  }
}
