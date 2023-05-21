import '../../../../core/core.dart';
import '../dtos/credentials.dart';

abstract interface class AuthService {
  AsyncAction<CreateUserOutput> signupStepOne(CreateUserInput input);
  AsyncAction<void> signupStepTwo(CredentialsDto input);
}
