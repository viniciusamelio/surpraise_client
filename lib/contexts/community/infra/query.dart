import '../../../core/core.dart';
import '../../../core/external_dependencies.dart';
import '../../../shared/dtos/dtos.dart';

class GetPraisesSentByUserQueryInput extends QueryInput {
  const GetPraisesSentByUserQueryInput({
    required this.userId,
    required this.praised,
    required this.communityId,
  });

  final String userId;
  final UserDto praised;
  final String communityId;
}

class GetPraisesSentByUserQueryOutput extends QueryOutput<List<PraiseDto>> {
  GetPraisesSentByUserQueryOutput(super.value);
}

class GetPraisesSentByUserQuery
    extends DataQuery<GetPraisesSentByUserQueryInput> {
  GetPraisesSentByUserQuery({
    required DatabaseDatasource databaseDatasource,
  }) : _datasource = databaseDatasource;

  final DatabaseDatasource _datasource;
  @override
  Future<Either<QueryError, GetPraisesSentByUserQueryOutput>> call(
    GetPraisesSentByUserQueryInput input,
  ) async {
    final result = await _datasource.get(
      GetQuery(
        sourceName: praisesCollection,
        operator: FilterOperator.equalsTo,
        value: input.praised.id,
        fieldName: "praised_id",
        orderBy: const OrderFilter(field: "created_at"),
        select:
            "*, $communitiesCollection(title), $profilesCollection!praise_praiser_id_fkey(name, tag, id, email), $reactionsCollection(id, reaction, user_id)",
        filters: [
          AndFilter(
            fieldName: "praiser_id",
            operator: FilterOperator.equalsTo,
            value: input.userId,
          ),
          AndFilter(
            fieldName: "community_id",
            operator: FilterOperator.equalsTo,
            value: input.communityId,
          ),
        ],
      ),
    );

    if (result.failure) {
      return Left(QueryError(result.errorMessage!));
    }

    return Right(
      GetPraisesSentByUserQueryOutput(
        result.multiData!
            .map(
              (e) => PraiseDto(
                id: e["id"],
                message: e["message"],
                topic: e["topic"],
                communityName: e[communitiesCollection]["title"],
                communityId: input.communityId,
                private: e["private"],
                praiser: UserDto(
                  tag: e[profilesCollection]["tag"],
                  name: e[profilesCollection]["name"],
                  email: e[profilesCollection]["email"],
                  id: e[profilesCollection]["id"],
                ),
                praised: input.praised,
                reactions: e[reactionsCollection] != null
                    ? (e[reactionsCollection] as List)
                        .cast<Map<String, dynamic>>()
                        .map(
                          (reaction) => PraiseReactionDto(
                            userId: reaction["user_id"],
                            id: reaction["id"],
                            praiseId: e["id"],
                            reaction: reaction["reaction"],
                          ),
                        )
                        .toList()
                    : [],
              ),
            )
            .toList(),
      ),
    );
  }
}
