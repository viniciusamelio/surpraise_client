import 'credentials.dart';

class SignupCredentialsDto extends CredentialsDto {
  const SignupCredentialsDto({
    required this.id,
    required super.email,
    required super.password,
  });

  final String id;
}
