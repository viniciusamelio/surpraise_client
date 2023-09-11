import 'package:ez_either/ez_either.dart';
import 'package:surpraise_infra/surpraise_infra.dart' hide CommunityRepository;

import '../../../../core/core.dart';
import '../../../../shared/dtos/user.dart';
import '../../community.dart';
import '../../dtos/dtos.dart';

class DefaultCommunityRepository implements CommunityRepository {
  DefaultCommunityRepository({
    required DatabaseDatasource databaseDatasource,
  }) : _datasource = databaseDatasource;

  final DatabaseDatasource _datasource;

  @override
  AsyncAction<List<CommunityOutput>> getCommunities(
    String userId,
  ) async {
    try {
      final communities = await _datasource.get(
        GetQuery(
            sourceName: communityMembersCollection,
            value: userId,
            fieldName: "member_id",
            select: "community(*)"),
      );

      return Right(
        (communities.multiData ?? [])
            .map<CommunityOutput>(
              (e) => communityOutputFromMap(e["community"]),
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

      if (user.multiData == null || user.multiData!.isEmpty) {
        return Left(Exception("User not found"));
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

  @override
  AsyncAction<List<FindCommunityMemberOutput>> getCommunityMembers(
    String id,
  ) async {
    try {
      final communities = await _datasource.get(
        GetQuery(
          sourceName: communityMembersCollection,
          value: id,
          fieldName: "community_id",
          select: "role, member_id, profile(tag, name, id)",
        ),
      );
      if (communities.failure) {
        return Left(
          Exception(
            "Something went wrong querying community members",
          ),
        );
      }
      return Right(
        communities.multiData!
            .map(
              (e) => FindCommunityMemberOutput(
                id: e["member_id"],
                communityId: id,
                role: e["role"],
                name: e["profile"]["name"],
                tag: e["profile"]["tag"],
              ),
            )
            .toList(),
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
