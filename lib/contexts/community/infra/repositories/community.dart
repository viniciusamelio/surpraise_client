import 'package:ez_either/ez_either.dart';
import 'package:surpraise_infra/surpraise_infra.dart' hide CommunityRepository;

import '../../../../core/core.dart';
import '../../../../shared/dtos/user.dart';
import '../../community.dart';

class DefaultCommunityRepository implements CommunityRepository {
  DefaultCommunityRepository({
    required DatabaseDatasource databaseDatasource,
  }) : _datasource = databaseDatasource;

  final DatabaseDatasource _datasource;

  @override
  AsyncAction<List<FindCommunityOutput>> getCommunities(String userId) async {
    try {
      final communities = await _datasource.get(
        GetQuery(
          sourceName: communitiesCollection,
          value: userId,
          fieldName: "user_id",
        ),
      );

      return Right(
        (communities.multiData ?? [])
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
      final user = await _datasource.get(
        GetQuery(
          sourceName: profilesCollection,
          value: tag,
          fieldName: "tag",
        ),
      );

      if (user.data == null) {
        return Right(null);
      }

      return Right(
        UserDto(
          tag: tag,
          name: user.multiData![0]["name"],
          email: user.multiData![0]["email"],
          id: user.multiData![0]["id"],
          password: null,
        ),
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  AsyncAction<CreateCommunityOutput> createCommunity(
    CreateCommunityInput input,
  ) async {
    try {
      final community = await _datasource.save(
        SaveQuery(
          sourceName: communitiesCollection,
          value: {
            "owner_id": input.ownerId,
            "imageUrl": input.imageUrl,
            "description": input.description,
            "title": input.title,
          },
        ),
      );

      await _datasource.save(
        SaveQuery(
          sourceName: communityMembersCollection,
          value: {
            "member_id": input.ownerId,
            "community_id": community.multiData![0]["id"],
            "role": "owner",
          },
        ),
      );

      return Right(
        CreateCommunityOutput(
          id: community.multiData![0]["id"],
          description: community.multiData![0]["description"],
          title: community.multiData![0]["title"],
          members: [
            {
              "member_id": input.ownerId,
              "community_id": community.multiData![0]["id"],
              "role": "owner",
            },
          ],
          ownerId: input.ownerId,
        ),
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
