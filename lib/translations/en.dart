// ignore_for_file: non_constant_identifier_names, file_names, camel_case_types, override_on_non_overriding_member
import './base_localization.dart';

class ENLocaleSyncLocalization implements BaseLocaleSyncLocalization {
  const ENLocaleSyncLocalization();

  @override
  String get flutterInitErrorMessage => "Something weird happened to the app";
  @override
  String get flutterInitButton => "Reboot app";
  @override
  String get welcome => "Welcomes to #surpraise";
  @override
  String get password => "Password";
  @override
  String get email => "E-mail";
  @override
  String get forgetPassword => "Forgot my password";
  @override
  String get name => "Name";
  @override
  String get tag => "Tag";
  @override
  String get profilePictureLabel => "Select your profile picture";
  @override
  String get signInLoading => "Loading...";
  @override
  String get signIn => "Sign in";
  @override
  String get orSignInWith => "Or sign in with";
  @override
  String get doesNotHaveAnAccount => "Doesn't have an account?";
  @override
  String get signUp => "Sign up";
  @override
  String get passwordReset => "Password reset";
  @override
  String get loading => "Loading";
  @override
  String get next => "Next";
  @override
  String get code => "Code";
  @override
  String get send => "Send";
  @override
  String get newPassword => "New password";
  @override
  String get confirmNewPassword => "Confirm new password";
  @override
  String get passwordsDoesntMatch => "Password does not match";
  @override
  String minValidation({required int count, required String name}) =>
      (count == 0
              ? "null"
              : count == 1
                  ? "{name} needs to be at least 1 char"
                  : "{name} needs to be at least {count} chars")
          .replaceAll("{name}", name)
          .replaceAll('{count}', count.toString());
  @override
  String maxValidation({required int count, required String name}) =>
      (count == 0
              ? "null"
              : count == 1
                  ? "{name} needs to be at most 1 char"
                  : "{name} needs to be at most {count} chars")
          .replaceAll("{name}", name)
          .replaceAll('{count}', count.toString());
  @override
  String get codeSendingError => "Something went wrong sending code";
  @override
  String get codeConfirmingError => "Something went wrong confirming code";
  @override
  String get passwordChangingSuccess => "Password changed";
  @override
  String get passwordChangingError => "Something went wrong changing password";
  @override
  String get signupTitle => "Sign up";
}
