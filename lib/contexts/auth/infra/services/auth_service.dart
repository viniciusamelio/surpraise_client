import 'package:dio/dio.dart';
import 'package:ez_either/ez_either.dart';
import 'package:surpraise_infra/surpraise_infra.dart';

import '../../../../core/core.dart';
import '../../auth.dart';

class DefaultAuthService implements AuthService {
  const DefaultAuthService({
    required SupabaseCloudClient supabaseClient,
    required HttpClient httpClient,
  })  : _supabase = supabaseClient,
        _client = httpClient;

  final SupabaseCloudClient _supabase;
  final HttpClient _client;

  @override
  AsyncAction<CreateUserOutput> signupStepOne(CreateUserInput input) async {
    try {
      final result = await _client.post<Json>(
        "/user/signup",
        data: UserMapper.createUserInputToMap(input),
      );
      return Right(
        UserMapper.createUserOutputFromMap(
          result.data!,
        ),
      );
    } on Exception catch (e) {
      if (e is TypeError) {
        return Left(
          const InvalidResponseException(
            message: "Unexpected response from /user/signup",
          ),
        );
      } else if (e is DioException && e.response?.statusCode == 400) {
        return Left(
          APIException(
            message:
                e.response?.data["error"]?["message"] ?? "Unknown API error",
          ),
        );
      }

      return Left(e);
    }
  }

  @override
  AsyncAction<SignupStatus> signupStepTwo(SignupCredentialsDto input) async {
    try {
      await _supabase.signUp(
        email: input.email,
        password: input.password,
        userId: input.id,
      );

      return Right(SignupStatus.success);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  AsyncAction<String> signinStepOne(SignInFormDataDto input) async {
    try {
      final result = await _supabase.signIn(
        email: input.username,
        password: input.password,
      );
      return Right(result);
    } on Exception catch (_) {
      return Left(
        InvalidCredentialsException(),
      );
    }
  }

  @override
  AsyncAction<GetUserOutput> signinStepTwo(String input) async {
    try {
      final result = await _client.get("/user/$input");
      return Right(
        GetUserOutput(
          tag: result.data["tag"],
          name: result.data["name"],
          email: result.data["email"],
          id: result.data["id"],
        ),
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  AsyncAction<void> logout() async {
    await _supabase.logout();
    return Right(null);
  }
}
