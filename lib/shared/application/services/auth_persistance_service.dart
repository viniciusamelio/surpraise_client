import '../../shared.dart';

abstract class AuthPersistanceService {
  Future<void> saveAuthenticatedUserData(UserDto user);
  Future<UserDto?> getAuthenticatedUser();
  Future<void> deleteAuthenticatedUserData();
}
