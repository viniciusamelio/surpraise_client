import '../../../../core/core.dart';
import '../../../../shared/dtos/praise.dart';
import '../../dtos/dtos.dart';

abstract class FeedRepository {
  AsyncAction<List<PraiseDto>> get({
    required String userId,
    int max,
    int offset,
  });

  AsyncAction<List<PraiseDto>> getByUser({
    required String userId,
    bool? asPraiser,
  });

  AsyncAction<List<InviteDto>> getInvites({
    required String userId,
  });
}
