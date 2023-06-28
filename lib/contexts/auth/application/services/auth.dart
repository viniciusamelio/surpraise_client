import 'package:surpraise_infra/surpraise_infra.dart';

import '../../../../core/core.dart';
import '../../dtos/dtos.dart';
import '../dtos/signup_credentials.dart';
import '../enums/signup_status.dart';

abstract interface class AuthService {
  AsyncAction<CreateUserOutput> signupStepOne(CreateUserInput input);
  AsyncAction<SignupStatus> signupStepTwo(SignupCredentialsDto input);

  AsyncAction<String> signinStepOne(SignInFormDataDto input);
  AsyncAction<GetUserOutput> signinStepTwo(String input);

  AsyncAction<void> logout();
}
