import 'package:surpraise_infra/surpraise_infra.dart';

class UserDto extends GetUserOutput {
  UserDto({
    required super.tag,
    required super.name,
    required super.email,
    required super.id,
    this.password,
    this.avatarUrl,
  });

  final String? avatarUrl;
  final String? password;

  UserDto copyWith({
    String? avatarUrl,
  }) {
    return UserDto(
      tag: tag,
      name: name,
      password: password,
      email: email,
      id: id,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
