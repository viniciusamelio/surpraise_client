import '../../core/core.dart';

import '../dtos/dtos.dart';
import 'saved_user.dart';

abstract class FeedPraiseMapper {
  static PraiseDto fromMap(Json map) => PraiseDto(
        id: map["id"],
        message: map["message"],
        topic: map["topic"],
        communityName: map["community"]["title"],
        communityId: map["community_id"],
        praiser: SavedUserMapper.fromMap(map["praiser"]),
        praised: SavedUserMapper.fromMap(map["praised"]),
      );
}
