import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../application/application.dart';

class DefaultInviteRepository implements InviteRepository {
  const DefaultInviteRepository({
    required DatabaseDatasource databaseDatasource,
  }) : _datasource = databaseDatasource;

  final DatabaseDatasource _datasource;

  @override
  AsyncAction<void> inviteMember({
    required String tag,
    required String communityId,
    required Role role,
  }) async {
    try {
      final invitedMemberOrError = await _datasource.save(
        SaveQuery(
          sourceName: invitesCollection,
          value: {
            "tag": tag,
            "community_id": communityId,
            "role": role.name,
          },
        ),
      );
      if (invitedMemberOrError.failure) {
        return Left(Exception("Something went wrong inviting member"));
      }
      return Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
