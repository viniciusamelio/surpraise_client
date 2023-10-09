import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../env.dart';
import '../../auth.dart';

class DefaultAuthService implements AuthService {
  const DefaultAuthService({
    required SupabaseCloudClient supabaseClient,
    required DatabaseDatasource databaseDatasource,
    required HttpClient httpClient,
  })  : _supabase = supabaseClient,
        _httpClient = httpClient,
        _datasource = databaseDatasource;

  final SupabaseCloudClient _supabase;
  final DatabaseDatasource _datasource;
  final HttpClient _httpClient;

  @override
  AsyncAction<GetUserOutput> signin(SignInFormDataDto input) async {
    try {
      final user = await _supabase.signIn(
        email: input.username,
        password: input.password,
      );
      final result = await _datasource.get(
        GetQuery(
          sourceName: "profile",
          operator: FilterOperator.equalsTo,
          value: user.id,
          fieldName: "id",
        ),
      );
      if (result.failure) {
        return Left(InvalidCredentialsException());
      }
      final data = result.multiData![0];
      return Right(
        GetUserOutput(
          tag: data["tag"],
          name: data["name"],
          email: data["email"],
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

      final result = await _datasource.save(
        SaveQuery(
          sourceName: "profile",
          value: {
            "name": input.name,
            "email": input.email,
            "tag": input.tag,
            "id": user.id,
          },
        ),
      );
      if (result.failure) {
        return Left(Exception("Something went wrong signing you up"));
      }

      return Right(
        UserMapper.createUserOutputFromMap(
          {
            ...result.multiData!.first,
            "id": user.id,
          },
        ),
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  AsyncAction<void> deleteAccount(String userId) async {
    try {
      await _httpClient.post(
        "${Env.sbUrl}/functions/v1/account-manager",
        data: {
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
}
