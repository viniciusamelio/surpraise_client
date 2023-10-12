import 'package:ez_either/ez_either.dart';
import 'package:surpraise_infra/surpraise_infra.dart' hide CommunityRepository;

import '../../../../core/core.dart';
import '../../community.dart';

class DefaultCommunityRepository implements CommunityRepository {
  const DefaultCommunityRepository({
    required DatabaseDatasource databaseDatasource,
  }) : _datasource = databaseDatasource;

  final DatabaseDatasource _datasource;

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
  AsyncAction<CreateCommunityOutput> updateCommunity(
    CreateCommunityInput input,
  ) async {
    final updatedCommunityOrError = await _datasource.save(
      SaveQuery(
        sourceName: communitiesCollection,
        value: {
          "imageUrl": input.imageUrl,
          "description": input.description,
          "title": input.title,
        },
        id: input.id,
      ),
    );

    if (updatedCommunityOrError.failure) {
      return Left(
        Exception("Something went wrong updating community"),
      );
    }

    return Right(
      CreateCommunityOutput(
        id: updatedCommunityOrError.multiData![0]["id"],
        description: updatedCommunityOrError.multiData![0]["description"],
        title: updatedCommunityOrError.multiData![0]["title"],
        members: [
          {
            "member_id": input.ownerId,
            "community_id": input.id,
            "role": "owner",
          },
        ],
        ownerId: input.ownerId,
      ),
    );
  }
}
