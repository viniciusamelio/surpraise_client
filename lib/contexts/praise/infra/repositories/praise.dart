import 'package:ez_either/ez_either.dart';

import '../../../../core/core.dart';
import '../../praise.dart';

class DefaultPraiseRepository implements PraiseRepository {
  DefaultPraiseRepository({
    required HttpClient httpClient,
  }) : _client = httpClient;
  final HttpClient _client;

  @override
  AsyncAction<void> send(PraiseInput input) async {
    try {
      await _client.post(
        "/praise",
        data: {
          "communityId": input.commmunityId,
          "message": input.message,
          "praisedId": input.praisedId,
          "praiserId": input.praiserId,
          "topic": input.topic
        },
      );

      return Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
