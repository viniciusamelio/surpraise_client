import 'dart:io';

import 'package:surpraise_infra/surpraise_infra.dart';

class UserDto extends GetUserOutput {
  UserDto({
    required super.tag,
    required super.name,
    required super.email,
    required super.id,
    this.password,
    this.avatarUrl,
    this.avatar,
  });

  String? avatarUrl;
  final String? password;
  File? avatar;

  void removeAvatar() {
    avatarUrl = null;
    avatar = null;
  }

  UserDto copyWith({
    String? avatarUrl,
    String? name,
    File? avatar,
  }) {
    return UserDto(
      tag: tag,
      name: name ?? this.name,
      password: password,
      email: email,
      id: id,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatar: avatar ?? this.avatar,
    );
  }
}
