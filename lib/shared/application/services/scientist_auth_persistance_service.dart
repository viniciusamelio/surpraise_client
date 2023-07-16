import '../../../core/core.dart';
import '../../mappers/saved_user.dart';
import '../../shared.dart';

class ScientistAuthPersistanceService implements AuthPersistanceService {
  const ScientistAuthPersistanceService({
    required ScientistDBService database,
  }) : _database = database;
  final ScientistDBService _database;

  final String _collection = "user";

  @override
  Future<void> saveAuthenticatedUserData(UserDto user) async {
    await _database.add(
      data: {
        ...SavedUserMapper.toMap(user),
        "_id": "userData",
      },
      collection: _collection,
    );
  }

  @override
  Future<UserDto?> getAuthenticatedUser() async {
    final userData = await _database.get(
      collection: _collection,
      equalsTo: "userData",
      field: "_id",
    );

    if (userData.isEmpty) {
      return null;
    }

    return SavedUserMapper.fromMap(
      userData.first,
    );
  }

  @override
  Future<void> deleteAuthenticatedUserData() async {
    await _database.delete(
      collection: _collection,
      equalsTo: "userData",
      field: "_id",
    );
  }
}
