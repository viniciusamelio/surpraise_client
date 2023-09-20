import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/dtos/dtos.dart';
import '../../../../shared/mappers/mappers.dart';
import '../../application/application.dart';
import '../../dtos/invite.dart';

class DefaultFeedRepository implements FeedRepository {
  const DefaultFeedRepository({
    required DatabaseDatasource databaseDatasource,
  }) : _databaseDatasource = databaseDatasource;

  final DatabaseDatasource _databaseDatasource;

  @override
  AsyncAction<List<PraiseDto>> get({
    required String userId,
  }) async {
    try {
      final communitiesOrError = await _databaseDatasource.get(
        GetQuery(
          sourceName: communityMembersCollection,
          value: userId,
          fieldName: "member_id",
          select: "$communitiesCollection(id)",
          filters: [
            AndFilter(
              fieldName: "active",
              operator: FilterOperator.equalsTo,
              value: true,
            ),
          ],
        ),
      );
      if (communitiesOrError.failure) {
        return Left(Exception("Something went wrong getting your communities"));
      }

      final ids = communitiesOrError.multiData!
          .map((e) => "${e[communitiesCollection]["id"]}")
          .toList();
      final List<PraiseDto> praises = [];

      for (final id in ids) {
        final feedPraises = await _databaseDatasource.get(
          GetQuery(
            sourceName: praisesCollection,
            value: id,
            fieldName: "community_id",
            select:
                "id, praiser_id, praised_id, community_id, message, topic, profile!praise_praiser_id_fkey(tag, name, id, email), $communitiesCollection(title)",
          ),
        );

        if (feedPraises.failure) {
          return Left(Exception("Something went wrong getting your feed"));
        }
        praises.addAll(
          feedPraises.multiData!.map<PraiseDto>(
            (e) => PraiseDto(
              id: e["id"],
              message: e["message"],
              topic: e["topic"],
              communityName: e[communitiesCollection]["title"],
              communityId: e["community_id"],
              praiser: UserDto(
                tag: e[profilesCollection]["tag"],
                name: e[profilesCollection]["name"],
                email: e[profilesCollection]["email"],
                id: e[profilesCollection]["id"],
              ),
            ),
          ),
        );
      }
      return Right(praises);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  AsyncAction<List<PraiseDto>> getByUser({
    required String userId,
    bool? asPraiser,
  }) async {
    try {
      final praisesOrError = await _getFeedByUser(
        userId: userId,
        asPraiser: asPraiser,
      );
      if (praisesOrError.failure) {
        return Left(Exception("Something went wrong getting your feeed"));
      }
      return Right(
        praisesOrError.multiData!
            .map<PraiseDto>(FeedPraiseMapper.fromMap)
            .toList(),
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<QueryResult> _getFeedByUser({
    required String userId,
    required bool? asPraiser,
  }) async {
    if (asPraiser != null) {
      return await _databaseDatasource.get(
        GetQuery(
          sourceName: praisesCollection,
          value: userId,
          fieldName: asPraiser ? "praiser_id" : "praised_id",
        ),
      );
    }
    return await _databaseDatasource.get(
      GetQuery(
        sourceName: praisesCollection,
        value: userId,
        fieldName: "praiser_id",
        filters: [
          OrFilter(
            fieldName: "praised_id",
            value: userId,
            operator: FilterOperator.equalsTo,
          ),
        ],
      ),
    );
  }

  @override
  AsyncAction<List<InviteDto>> getInvites({
    required String userId,
  }) async {
    try {
      final invitesOrError = await _databaseDatasource.get(
        GetQuery(
            sourceName: invitesCollection,
            value: userId,
            fieldName: "member_id",
            select: "id,community_id, role, community(title)",
            filters: [
              AndFilter(
                fieldName: "status",
                operator: FilterOperator.equalsTo,
                value: "pending",
              ),
            ]),
      );

      if (invitesOrError.failure) {
        return Left(Exception("Sometihng went wrong getting invites"));
      }

      return Right(
        invitesOrError.multiData!.map(inviteFromMap).toList(),
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
