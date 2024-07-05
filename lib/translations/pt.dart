// ignore_for_file: non_constant_identifier_names, file_names, camel_case_types, override_on_non_overriding_member
import './base_localization.dart';

class PTLocaleSyncLocalization implements BaseLocaleSyncLocalization {
  const PTLocaleSyncLocalization();

  @override
  String get flutterInitErrorMessage => "Algo estranho aconteceu com o app";
  @override
  String get flutterInitButton => "Reiniciar o app";
  @override
  String get welcome => "Boas vindas ao #surpraise";
  @override
  String get password => "Senha";
  @override
  String get email => "E-mail";
  @override
  String get forgetPassword => "Esqueci minha senha";
  @override
  String get name => "Nome";
  @override
  String get tag => "Tag";
  @override
  String get profilePictureLabel => "Seleciona sua foto de perfil";
  @override
  String get signInLoading => "Carregando...";
  @override
  String get signIn => "Entrar";
  @override
  String get orSignInWith => "Ou entre com";
  @override
  String get doesNotHaveAnAccount => "Não possui uma conta?";
  @override
  String get signUp => "Cadastre-se";
  @override
  String get passwordReset => "Reset de senha";
  @override
  String get loading => "Carregando";
  @override
  String get next => "Próximo";
  @override
  String get code => "Código";
  @override
  String get send => "Enviar";
  @override
  String get newPassword => "Nova senha";
  @override
  String get confirmNewPassword => "Confirmar nova senha";
  @override
  String get passwordsDoesntMatch => "As senhas não coincidem";
  @override
  String minValidation({required int count, required String name}) =>
      (count == 0
              ? "null"
              : count == 1
                  ? "{name} deve ter no mínimo 1 caracter"
                  : "{name} deve ter no mínimo {count} caracteres")
          .replaceAll("{name}", name)
          .replaceAll('{count}', count.toString());
  @override
  String maxValidation({required int count, required String name}) =>
      (count == 0
              ? "null"
              : count == 1
                  ? "{name} deve ter no máximo um caracter"
                  : "{name} deve ter no máximo {count} caracteres")
          .replaceAll("{name}", name)
          .replaceAll('{count}', count.toString());
  @override
  String get codeSendingError => "Deu ruim ao enviar o código";
  @override
  String get codeConfirmingError => "Deu ruim ao confirmar o código";
  @override
  String get passwordChangingSuccess => "Senha alterada";
  @override
  String get passwordChangingError => "Deu ruim ao alterar a senha";
  @override
  String get signupTitle => "Crie sua conta";
}
