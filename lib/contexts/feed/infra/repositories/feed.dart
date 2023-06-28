import 'package:ez_either/ez_either.dart';
import 'package:surpraise_client/shared/mappers/mappers.dart';

import '../../../../core/core.dart';
import '../../../../shared/dtos/dtos.dart';
import '../../application/application.dart';

class DefaultFeedRepository implements FeedRepository {
  const DefaultFeedRepository({
    required HttpClient httpClient,
  }) : _httpClient = httpClient;

  final HttpClient _httpClient;

  @override
  AsyncAction<List<PraiseDto>> getByUser(String userId) async {
    try {
      final praises = await _httpClient.get(
        "/user/$userId",
      );
      return Right(
        (praises.data["praises"] as List<Json>)
            .map<PraiseDto>(
              (e) => FeedPraiseMapper.fromMap(e),
            )
            .toList(),
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
