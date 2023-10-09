import 'package:surpraise_infra/surpraise_infra.dart';

import '../../../../core/core.dart';
import '../../dtos/dtos.dart';
import '../dtos/signup_credentials.dart';

abstract interface class AuthService {
  AsyncAction<CreateUserOutput> signup(SignupCredentialsDto input);
  AsyncAction<GetUserOutput> signin(SignInFormDataDto input);
  AsyncAction<void> logout();
  AsyncAction<void> deleteAccount(String userId);
  AsyncAction<void> requestPasswordReset(String email);
  AsyncAction<void> confirmRecoveryCode(String code);
  AsyncAction<void> confirmPasswordReset(String password);
}
