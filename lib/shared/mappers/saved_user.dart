import '../../core/core.dart';
import '../shared.dart';

abstract class SavedUserMapper {
  static Json toMap(UserDto user) {
    return {
      "tag": user.tag,
      "email": user.email,
      "name": user.name,
      "id": user.id,
      "password": user.password,
    };
  }

  static UserDto fromMap(Json json) {
    return UserDto(
      tag: json["tag"],
      name: json["name"],
      email: json["email"],
      id: json["id"],
      password: json["password"],
    );
  }
}
