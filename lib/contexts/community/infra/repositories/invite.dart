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
    required String inviteId,
    required bool accepted,
  }) async {
    try {
      final answerOrError = await _datasource.save(
        SaveQuery(
          sourceName: invitesCollection,
          value: {
            "status": accepted ? "accepted" : "rejected",
            "updated_at": DateTime.now().toIso8601String(),
          },
          id: inviteId,
        ),
      );
      if (answerOrError.failure) {
        return Left(Exception("Something went wrong answering invitation"));
      }

      if (accepted) {
        final addResultOrError = await addMember(inviteId: inviteId);
        if (addResultOrError.isLeft()) {
          return Left(addResultOrError.fold((left) => left, (right) => null)!);
        }
      }

      return Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  AsyncAction<void> addMember({
    required String inviteId,
  }) async {
    try {
      final inviteOrError = await _datasource.get(
        GetQuery(
          sourceName: invitesCollection,
          value: inviteId,
          fieldName: "id",
        ),
      );
      if (inviteOrError.failure) {
        return Left(Exception("Something went wrong adding member"));
      }

      final communityMemberOrError = await _datasource.save(
        SaveQuery(
          sourceName: communityMembersCollection,
          value: {
            "member_id": inviteOrError.multiData![0]["member_id"],
            "community_id": inviteOrError.multiData![0]["community_id"],
            "role": inviteOrError.multiData![0]["role"],
            "active": true,
          },
        ),
      );

      if (communityMemberOrError.failure) {
        return Left(Exception("Something went wrong adding member"));
      }

      return Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
