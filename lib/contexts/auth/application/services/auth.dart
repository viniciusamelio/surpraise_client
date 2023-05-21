import '../../../../core/core.dart';
import '../dtos/signup_credentials.dart';
import '../enums/signup_status.dart';

abstract interface class AuthService {
  AsyncAction<CreateUserOutput> signupStepOne(CreateUserInput input);
  AsyncAction<SignupStatus> signupStepTwo(SignupCredentialsDto input);
}
