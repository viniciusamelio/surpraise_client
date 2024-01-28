import '../../core/core.dart';
import '../../core/external_dependencies.dart' hide Json;
import '../shared.dart';

abstract class SavedUserMapper {
  static Json toMap(UserDto user) {
    return {
      "tag": user.tag,
      "email": user.email,
      "name": user.name,
      "id": user.id,
      "avatarUrl": user.avatarUrl,
      "lastInteractedCommunity": user.lastInteractedCommunity != null
          ? {
              "id": user.lastInteractedCommunity!.id,
              "title": user.lastInteractedCommunity!.title,
              "description": user.lastInteractedCommunity!.description,
              "imageUrl": user.lastInteractedCommunity!.image,
              "owner_id": user.lastInteractedCommunity!.ownerId,
              "role": user.lastInteractedCommunity!.role.value,
            }
          : null,
    };
  }

  static UserDto fromMap(Map json) {
    return UserDto(
      tag: json["tag"],
      name: json["name"],
      email: json["email"],
      id: json["id"],
      avatarUrl: json["avatarUrl"],
      lastInteractedCommunity: json["lastInteractedCommunity"] != null
          ? communityOutputFromMap(
              (json["lastInteractedCommunity"] as Map).cast<String, dynamic>(),
            )
          : null,
    );
  }
}
