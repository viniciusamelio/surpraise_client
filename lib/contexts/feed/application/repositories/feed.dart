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
    int offset = 0,
    bool withPrivate,
  });

  AsyncAction<List<InviteDto>> getInvites({
    required String userId,
  });

  AsyncAction<String> toggleReaction({
    required String userId,
    required String praiseId,
    required String reaction,
    String? reactionId,
  });
}
