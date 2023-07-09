import 'package:ez_either/ez_either.dart';
import 'package:surpraise_infra/surpraise_infra.dart' hide CommunityRepository;

import '../../../../core/core.dart';
import '../../../../shared/dtos/user.dart';
import '../../community.dart';

class DefaultCommunityRepository implements CommunityRepository {
  DefaultCommunityRepository({
    required HttpClient httpClient,
  }) : _httpClient = httpClient;

  final HttpClient _httpClient;
  @override
  AsyncAction<List<FindCommunityOutput>> getCommunities(String userId) async {
    try {
      final communities = await _httpClient.get("/community/user/$userId");
      if (communities.data["communities"].isEmpty) {
        return Right([]);
      }

      return Right(
        communities.data["communities"]
            .map<FindCommunityOutput>(
              (e) => CommunityMapper.findOutputFromMap(
                e,
              ),
            )
            .toList(),
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  AsyncAction<UserDto?> getUserByTag(String tag) async {
    try {
      final user = await _httpClient.get("/user/tag/$tag");

      if (user.data == null) {
        return Right(null);
      }

      return Right(
        UserDto(
          tag: tag,
          name: user.data["name"],
          email: user.data["email"],
          id: user.data["id"],
          password: null,
        ),
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
