// ignore_for_file: non_constant_identifier_names, file_names, camel_case_types, override_on_non_overriding_member
import './base_localization.dart';

class In_Memory_LocaleSyncLocalization implements BaseLocaleSyncLocalization {
  const In_Memory_LocaleSyncLocalization({
    required this.map,
    required this.language,
  });
  final Map<String, dynamic> map;
  final String language;

  @override
  String get flutterInitErrorMessage =>
      map[language]["flutterInitErrorMessage"]['value'];
  @override
  String get flutterInitButton => map[language]["flutterInitButton"]['value'];
  @override
  String get welcome => map[language]["welcome"]['value'];
  @override
  String get password => map[language]["password"]['value'];
  @override
  String get email => map[language]["email"]['value'];
  @override
  String get forgetPassword => map[language]["forgetPassword"]['value'];
  @override
  String get name => map[language]["name"]['value'];
  @override
  String get tag => map[language]["tag"]['value'];
  @override
  String get profilePictureLabel =>
      map[language]["profilePictureLabel"]['value'];
  @override
  String get signInLoading => map[language]["signInLoading"]['value'];
  @override
  String get signIn => map[language]["signIn"]['value'];
  @override
  String get orSignInWith => map[language]["orSignInWith"]['value'];
  @override
  String get doesNotHaveAnAccount =>
      map[language]["doesNotHaveAnAccount"]['value'];
  @override
  String get signUp => map[language]["signUp"]['value'];
  @override
  String get passwordReset => map[language]["passwordReset"]['value'];
  @override
  String get loading => map[language]["loading"]['value'];
  @override
  String get next => map[language]["next"]['value'];
  @override
  String get code => map[language]["code"]['value'];
  @override
  String get send => map[language]["send"]['value'];
  @override
  String get newPassword => map[language]["newPassword"]['value'];
  @override
  String get confirmNewPassword => map[language]["confirmNewPassword"]['value'];
  @override
  String get passwordsDoesntMatch =>
      map[language]["passwordsDoesntMatch"]['value'];
  @override
  String minValidation({required int count, required String name}) =>
      (count == 1
              ? map[language]["minValidation"]['value']
              : count == 0
                  ? map[language]["minValidation"]['none']
                  : map[language]["minValidation"]['plural'])
          .replaceAll("{name}", name)
          .replaceAll('{count}', count.toString());
  @override
  String maxValidation({required int count, required String name}) =>
      (count == 1
              ? map[language]["maxValidation"]['value']
              : count == 0
                  ? map[language]["maxValidation"]['none']
                  : map[language]["maxValidation"]['plural'])
          .replaceAll("{name}", name)
          .replaceAll('{count}', count.toString());
  @override
  String get codeSendingError => map[language]["codeSendingError"]['value'];
  @override
  String get codeConfirmingError =>
      map[language]["codeConfirmingError"]['value'];
  @override
  String get passwordChangingSuccess =>
      map[language]["passwordChangingSuccess"]['value'];
  @override
  String get passwordChangingError =>
      map[language]["passwordChangingError"]['value'];
  @override
  String get signupTitle => map[language]["signupTitle"]['value'];
}
