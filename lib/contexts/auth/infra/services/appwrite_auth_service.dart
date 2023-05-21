import '../../../../core/core.dart';
import '../../application/dtos/credentials.dart';
import '../../application/services/auth.dart';

class AppWriteAuthService implements AuthService {
  const AppWriteAuthService({
    required AppWriteService appWriteAuthService,
  }) : _appWriteService = appWriteAuthService;

  final AppWriteService _appWriteService;

  @override
  AsyncAction<CreateUserOutput> signupStepOne(CreateUserInput input) async {
    // TODO: implement signupStepOne
    throw UnimplementedError();
  }

  @override
  AsyncAction<void> signupStepTwo(CredentialsDto input) {
    // TODO: implement signupStepTwo
    throw UnimplementedError();
  }
}
