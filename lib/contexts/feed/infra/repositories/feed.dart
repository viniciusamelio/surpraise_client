import 'package:ez_either/ez_either.dart';

import '../../../../core/core.dart';
import '../../../../shared/dtos/dtos.dart';
import '../../../../shared/mappers/mappers.dart';
import '../../application/application.dart';

class DefaultFeedRepository implements FeedRepository {
  const DefaultFeedRepository({
    required HttpClient httpClient,
  }) : _httpClient = httpClient;

  final HttpClient _httpClient;

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
}
