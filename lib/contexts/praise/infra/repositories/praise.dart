import 'package:ez_either/ez_either.dart';
import 'package:surpraise_infra/surpraise_infra.dart' hide PraiseRepository;

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
        data: PraiseMapper.inputToMap(
          input,
        ),
      );

      return Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
