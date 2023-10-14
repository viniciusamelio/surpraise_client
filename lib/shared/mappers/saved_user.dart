import '../../core/core.dart';
import '../shared.dart';

abstract class SavedUserMapper {
  static Json toMap(UserDto user) {
    return {
      "tag": user.tag,
      "email": user.email,
      "name": user.name,
      "id": user.id,
      "avatarUrl": user.avatarUrl
    };
  }

  static UserDto fromMap(Map json) {
    return UserDto(
      tag: json["tag"],
      name: json["name"],
      email: json["email"],
      id: json["id"],
      avatarUrl: json["avatarUrl"],
    );
  }
}
