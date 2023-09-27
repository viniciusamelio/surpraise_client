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
    this.cachedAvatar,
  });

  String? avatarUrl;
  final String? password;
  File? cachedAvatar;

  void removeAvatar() {
    avatarUrl = null;
    cachedAvatar = null;
  }

  UserDto copyWith({
    String? avatarUrl,
    String? name,
    File? cachedAvatar,
  }) {
    return UserDto(
      tag: tag,
      name: name ?? this.name,
      password: password,
      email: email,
      id: id,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      cachedAvatar: cachedAvatar ?? this.cachedAvatar,
    );
  }
}
