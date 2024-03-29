import 'dart:io';

import 'package:surpraise_infra/surpraise_infra.dart';

class UserDto extends GetUserOutput {
  UserDto(
      {required super.tag,
      required super.name,
      required super.email,
      required super.id,
      this.avatarUrl,
      this.cachedAvatar,
      this.lastInteractedCommunity});

  String? avatarUrl;
  File? cachedAvatar;
  CommunityOutput? lastInteractedCommunity;

  void removeAvatar() {
    avatarUrl = null;
    cachedAvatar = null;
  }

  UserDto copyWith({
    String? avatarUrl,
    String? name,
    File? cachedAvatar,
    CommunityOutput? lastInteractedCommunity,
  }) {
    return UserDto(
      tag: tag,
      name: name ?? this.name,
      email: email,
      id: id,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      cachedAvatar: cachedAvatar ?? this.cachedAvatar,
      lastInteractedCommunity:
          lastInteractedCommunity ?? this.lastInteractedCommunity,
    );
  }
}
