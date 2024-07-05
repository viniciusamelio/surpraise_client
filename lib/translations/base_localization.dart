// ignore_for_file: non_constant_identifier_names
abstract interface class BaseLocaleSyncLocalization {
  const BaseLocaleSyncLocalization();
  String get flutterInitErrorMessage;
  String get flutterInitButton;
  String get welcome;
  String get password;
  String get email;
  String get forgetPassword;
  String get name;
  String get tag;
  String get profilePictureLabel;
  String get signInLoading;
  String get signIn;
  String get orSignInWith;
  String get doesNotHaveAnAccount;
  String get signUp;
  String get passwordReset;
  String get loading;
  String get next;
  String get code;
  String get send;
  String get newPassword;
  String get confirmNewPassword;
  String get passwordsDoesntMatch;
  String minValidation({required int count, required String name});
  String maxValidation({required int count, required String name});
  String get codeSendingError;
  String get codeConfirmingError;
  String get passwordChangingSuccess;
  String get passwordChangingError;
  String get signupTitle;
}
