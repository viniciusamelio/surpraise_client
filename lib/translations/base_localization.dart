// ignore_for_file: non_constant_identifier_names
abstract interface class BaseLocaleSyncLocalization {
  const BaseLocaleSyncLocalization();

  /// **Algo estranho aconteceu com o app** on pt language <br>
  String get flutterInitErrorMessage;

  /// **Reiniciar o app** on pt language <br>
  String get flutterInitButton;

  /// **Boas vindas ao #surpraise** on pt language <br>
  String get welcome;

  /// **Senha** on pt language <br>
  String get password;

  /// **E-mail** on pt language <br>
  String get email;

  /// **Esqueci minha senha** on pt language <br>
  String get forgetPassword;

  /// **Nome** on pt language <br>
  String get name;

  /// **Tag** on pt language <br>
  String get tag;

  /// **Seleciona sua foto de perfil** on pt language <br>
  String get profilePictureLabel;

  /// **Carregando...** on pt language <br>
  String get signInLoading;

  /// **Entrar** on pt language <br>
  String get signIn;

  /// **Ou entre com** on pt language <br>
  String get orSignInWith;

  /// **Não possui uma conta?** on pt language <br>
  String get doesNotHaveAnAccount;

  /// **Cadastre-se** on pt language <br>
  String get signUp;

  /// **Reset de senha** on pt language <br>
  String get passwordReset;

  /// **Carregando** on pt language <br>
  String get loading;

  /// **Próximo** on pt language <br>
  String get next;

  /// **Código** on pt language <br>
  String get code;

  /// **Enviar** on pt language <br>
  String get send;

  /// **Nova senha** on pt language <br>
  String get newPassword;

  /// **Confirmar nova senha** on pt language <br>
  String get confirmNewPassword;

  /// **As senhas não coincidem** on pt language <br>
  String get passwordsDoesntMatch;

  /// **{name} deve ter no mínimo 1 caracter** on pt language <br>
  /// plural: **{name} deve ter no mínimo {count} caracteres** <br>
  String minValidation({required int count, required String name});

  /// **{name} deve ter no máximo um caracter** on pt language <br>
  /// plural: **{name} deve ter no máximo {count} caracteres** <br>
  String maxValidation({required int count, required String name});

  /// **Deu ruim ao enviar o código** on pt language <br>
  String get codeSendingError;

  /// **Deu ruim ao confirmar o código** on pt language <br>
  String get codeConfirmingError;

  /// **Senha alterada** on pt language <br>
  String get passwordChangingSuccess;

  /// **Deu ruim ao alterar a senha** on pt language <br>
  String get passwordChangingError;

  /// **Crie sua conta** on pt language <br>
  String get signupTitle;
}
