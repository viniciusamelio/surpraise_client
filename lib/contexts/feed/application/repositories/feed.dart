import '../../../../core/core.dart';
import '../../../../shared/dtos/praise.dart';

abstract class FeedRepository {
  AsyncAction<List<PraiseDto>> getByUser(String userId);
}
