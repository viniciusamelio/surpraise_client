import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/dtos/dtos.dart';
import '../../../../shared/mappers/mappers.dart';
import '../../application/application.dart';
import '../../dtos/invite.dart';

class DefaultFeedRepository implements FeedRepository {
  const DefaultFeedRepository({
    required HttpClient httpClient,
    required DatabaseDatasource databaseDatasource,
  })  : _httpClient = httpClient,
        _databaseDatasource = databaseDatasource;

  final HttpClient _httpClient;
  final DatabaseDatasource _databaseDatasource;

  @override
  AsyncAction<List<PraiseDto>> getByUser({
    required String userId,
    bool? asPraiser,
  }) async {
    try {
      final praises = await _httpClient.get(
        "/praise/user/$userId",
        queryParameters: {
          "asPraiser": asPraiser,
        },
      );
      if (praises.data["praises"].isEmpty) {
        return Right([]);
      }
      return Right(
        (praises.data["praises"] as List? ?? [])
            .map<PraiseDto>(
              (e) => FeedPraiseMapper.fromMap(e),
            )
            .toList(),
      );
    } on Exception catch (e) {
      return Left(e);
    }
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
          select: "community_id, role, community(title)",
        ),
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
