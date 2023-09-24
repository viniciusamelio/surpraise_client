import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../env.dart';
import '../../../../shared/dtos/dtos.dart';
import '../../application/application.dart';
import '../../dtos/invite.dart';

class DefaultFeedRepository implements FeedRepository {
  const DefaultFeedRepository({
    required DatabaseDatasource databaseDatasource,
    required HttpClient httpClient,
  })  : _databaseDatasource = databaseDatasource,
        _httpClient = httpClient;

  final DatabaseDatasource _databaseDatasource;
  final HttpClient _httpClient;

  @override
  AsyncAction<List<PraiseDto>> get({
    required String userId,
  }) async {
    try {
      final feed = await _httpClient.post(
        "${Env.sbUrl}/functions/v1/feed",
        data: {
          "userId": userId,
        },
      );
      if (feed.statusCode != 200) {
        return Left(Exception("Something went wrong getting your feed"));
      }

      return Right(
        (feed.data as List)
            .map<PraiseDto>(
              (e) => PraiseDto(
                id: e["praise_id"],
                message: e["message"],
                topic: e["topic"],
                communityName: e["title"],
                communityId: e["community_id"],
                praiser: UserDto(
                  tag: e["praiser_tag"],
                  name: e["praiser_name"],
                  email: e["praiser_email"],
                  id: e["praiser_id"],
                ),
                praised: UserDto(
                  tag: e["praised_tag"],
                  name: e["praised_name"],
                  email: e["praised_email"],
                  id: e["praised_id"],
                ),
              ),
            )
            .toList(),
      );
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
      );
      if (praisesOrError.failure) {
        return Left(Exception("Something went wrong getting your feeed"));
      }
      return Right(
        praisesOrError.multiData!.map<PraiseDto>((e) {
          return PraiseDto(
            id: e["id"],
            message: e["message"],
            topic: e["topic"],
            communityName: e["community"]["title"],
            communityId: e["community_id"],
            praiser: UserDto(
              tag: e["profile"]["tag"],
              name: e["profile"]["name"],
              email: e["profile"]["email"],
              id: e["profile"]["id"],
            ),
          );
        }).toList(),
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<QueryResult> _getFeedByUser({
    required String userId,
  }) async {
    const String select =
        "*, $communitiesCollection(title), $profilesCollection!praise_praiser_id_fkey(name, tag, id, email)";

    return await _databaseDatasource.get(
      GetQuery(
        sourceName: praisesCollection,
        value: userId,
        fieldName: "praised_id",
        select: select,
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
