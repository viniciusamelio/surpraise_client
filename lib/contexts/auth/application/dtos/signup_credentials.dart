import 'credentials.dart';

class SignupCredentialsDto extends CredentialsDto {
  const SignupCredentialsDto({
    required this.tag,
    required super.email,
    required super.password,
    required this.name,
  });

  final String tag;
  final String name;
}
