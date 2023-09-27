import 'package:hive/hive.dart';

import '../../dtos/user.dart';
import '../../mappers/saved_user.dart';
import '../application.dart';

class HiveAuthPersistanceService implements AuthPersistanceService {
  const HiveAuthPersistanceService({
    required Box hiveBox,
  }) : _box = hiveBox;
  final Box _box;

  @override
  Future<void> deleteAuthenticatedUserData() async {
    await _box.delete("user");
  }

  @override
  Future<UserDto?> getAuthenticatedUser() async {
    final user = _box.get("user");
    if (user == null) return null;
    return SavedUserMapper.fromMap(user);
  }

  @override
  Future<void> saveAuthenticatedUserData(UserDto user) async {
    await _box.put("user", SavedUserMapper.toMap(user));
  }
}
