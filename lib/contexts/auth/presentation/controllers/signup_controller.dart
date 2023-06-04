import '../../auth.dart';

abstract class SignupController {
  SignupFormDataDto get formData;
  Future<void> signup();
}
