import 'package:surpraise_infra/surpraise_infra.dart';

import '../../../../core/core.dart';
import '../../dtos/dtos.dart';
import '../dtos/signup_credentials.dart';

enum SocialProvider { discord, github, slack, google }

abstract interface class AuthService {
  AsyncAction<CreateUserOutput> signup(SignupCredentialsDto input);
  AsyncAction<GetUserOutput> signin(SignInFormDataDto input);
  AsyncAction<void> socialLogin(SocialProvider provider);
  AsyncAction<void> logout();
  AsyncAction<void> deleteAccount(String userId);
  AsyncAction<void> requestPasswordReset(String email);
  AsyncAction<void> confirmRecoveryCode({
    required String code,
    required String email,
  });
  AsyncAction<void> confirmPasswordReset(String password);
}
