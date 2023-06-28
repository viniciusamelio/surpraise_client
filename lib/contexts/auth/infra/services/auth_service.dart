import 'package:appwrite/appwrite.dart';
import 'package:dio/dio.dart';
import 'package:ez_either/ez_either.dart';
import 'package:surpraise_infra/surpraise_infra.dart';

import '../../../../core/core.dart';
import '../../auth.dart';

class DefaultAuthService implements AuthService {
  const DefaultAuthService({
    required AppWriteService appWriteAuthService,
    required HttpClient httpClient,
  })  : _appWriteService = appWriteAuthService,
        _client = httpClient;

  final AppWriteService _appWriteService;
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
      final result = await _appWriteService.signUp(
        email: input.email,
        password: input.password,
        userId: input.id,
      );
      if (result.emailVerification) {
        return Right(SignupStatus.verification);
      }

      return Right(SignupStatus.success);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  AsyncAction<String> signinStepOne(SignInFormDataDto input) async {
    try {
      final result = await _appWriteService.signIn(
        email: input.username,
        password: input.password,
      );
      return Right(result);
    } on Exception catch (e) {
      if (e is AppwriteException && [400, 401].contains(e.code)) {
        return Left(
          InvalidCredentialsException(),
        );
      }
      return Left(e);
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
    await _appWriteService.logout();
    return Right(null);
  }
}
