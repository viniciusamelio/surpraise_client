import 'dart:convert';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/dtos/dtos.dart';
import '../../application/application.dart';
import '../../dtos/invite.dart';

class DefaultFeedRepository implements FeedRepository {
  const DefaultFeedRepository({
    required DatabaseDatasource databaseDatasource,
    required SupabaseCloudClient supabaseCloudClient,
  })  : _databaseDatasource = databaseDatasource,
        _supabaseClient = supabaseCloudClient;

  final DatabaseDatasource _databaseDatasource;

  final SupabaseCloudClient _supabaseClient;

  @override
  AsyncAction<List<PraiseDto>> get({
    required String userId,
    int max = 10,
    int offset = 0,
  }) async {
    try {
      final feed = await _supabaseClient.supabase.functions.invoke("feed",
          body: {
            "userId": userId,
            "max": max,
            "offset": offset,
          },
          headers: {
            "Content-Type": "application/json;charset=UTF-8",
          },
          responseType: ResponseType.text);
      if (feed.status != 200) {
        return Left(Exception("Something went wrong getting your feed"));
      }

      return Right(
        (jsonDecode(feed.data) as List).map<PraiseDto>(
          (e) {
            final reactions = e["reactions"];
            return PraiseDto(
              id: e["praise_id"],
              message: e["message"],
              topic: e["topic"],
              communityName: e["title"],
              communityId: e["community_id"],
              reactions: reactions != null
                  ? reactions
                      .map<PraiseReactionDto>(
                        (r) => PraiseReactionDto(
                          userId: r["user_id"],
                          praiseId: e["praise_id"],
                          reaction: r["reaction"],
                          id: r["id"],
                        ),
                      )
                      .toList()
                  : <PraiseReactionDto>[],
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
              extraPraiseds: e["extra_praiseds"] != null
                  ? e["extra_praiseds"]
                      .map((e) => e["praised_id"])
                      .toSet()
                      .toList()
                      .cast<String>()
                  : <String>[],
            );
          },
        ).toList(),
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  AsyncAction<List<PraiseDto>> getByUser({
    required String userId,
    int offset = 0,
    bool? asPraiser,
    bool withPrivate = false,
  }) async {
    try {
      final praisesOrError = await _getFeedByUser(
        userId: userId,
        offset: offset,
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
    required int offset,
    bool withPrivate = false,
  }) async {
    const String select =
        "*, $communitiesCollection(title), $profilesCollection!praise_praiser_id_fkey(name, tag, id, email)";

    return await _databaseDatasource.get(
      GetQuery(
        sourceName: praisesCollection,
        value: userId,
        fieldName: "praised_id",
        select: select,
        orderBy: const OrderFilter(
          field: "created_at",
        ),
        offset: offset,
        limit: 10,
        filters: withPrivate
            ? [
                AndFilter(
                  fieldName: "private",
                  value: false,
                  operator: FilterOperator.equalsTo,
                ),
              ]
            : null,
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

  @override
  AsyncAction<String> toggleReaction({
    required String userId,
    required String praiseId,
    required String reaction,
    String? reactionId,
  }) async {
    if (reactionId != null) {
      await _databaseDatasource.delete(
        GetQuery(
          sourceName: reactionsCollection,
          value: reactionId,
          fieldName: "id",
        ),
      );
      return Right(reactionId);
    }
    final savedOrError = await _databaseDatasource.save(
      SaveQuery(
        sourceName: reactionsCollection,
        value: {
          "user_id": userId,
          "praise_id": praiseId,
          "reaction": reaction,
        },
      ),
    );
    if (savedOrError.failure) {
      return Left(Exception("Something went wrong saving reaction"));
    }
    return Right(savedOrError.data!["id"]);
  }
}
