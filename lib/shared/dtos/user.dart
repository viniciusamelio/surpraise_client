import 'dart:io';

import 'package:surpraise_infra/surpraise_infra.dart';

class UserDto extends GetUserOutput {
  UserDto({
    required super.tag,
    required super.name,
    required super.email,
    required super.id,
    this.password,
    this.avatar,
  });

  final File? avatar;
  final String? password;

  UserDto copyWith({
    File? avatar,
  }) {
    return UserDto(
      tag: tag,
      name: name,
      password: password,
      email: email,
      id: id,
      avatar: avatar ?? this.avatar,
    );
  }
}
