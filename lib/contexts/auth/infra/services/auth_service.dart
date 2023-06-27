import 'package:ez_either/ez_either.dart';
import 'package:surpraise_client/contexts/auth/dtos/signin_form_data.dart';
import 'package:surpraise_infra/surpraise_infra.dart';

import '../../../../core/core.dart';
import '../../application/dtos/signup_credentials.dart';
import '../../application/enums/signup_status.dart';
import '../../application/services/auth.dart';

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
    // TODO: implement signinStepOne
    throw UnimplementedError();
  }

  @override
  AsyncAction<GetUserOutput> signinStepTwo(String input) async {
    // TODO: implement signinStepTwo
    throw UnimplementedError();
  }
}
