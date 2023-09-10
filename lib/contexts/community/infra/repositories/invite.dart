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
    required String memberId,
    required String communityId,
    required Role role,
  }) async {
    try {
      final invitedMemberOrError = await _datasource.save(
        SaveQuery(
          sourceName: invitesCollection,
          value: {
            "member_id": memberId,
            "community_id": communityId,
            "role": role.value,
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

  @override
  AsyncAction<void> answerInvitation({
    required String memberId,
    required String communityId,
    required bool accepted,
  }) async {
    try {
      final answerOrError = await _datasource.save(
        SaveQuery(
          sourceName: invitesCollection,
          value: {
            "member_id": memberId,
            "community_id": communityId,
            "status": accepted ? "accepted" : "rejected",
          },
        ),
      );
      if (answerOrError.failure) {
        return Left(Exception("Something went wrong answering invitation"));
      }

      return Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
