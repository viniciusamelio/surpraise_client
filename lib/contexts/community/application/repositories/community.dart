import 'package:surpraise_infra/surpraise_infra.dart';

import '../../../../core/core.dart';
import '../../dtos/dtos.dart';

abstract class CommunityRepository {
  AsyncAction<List<ListUserCommunitiesOutput>> getCommunities(String userId);
  AsyncAction<GetUserOutput?> getUserByTag(String tag);
  AsyncAction<CreateCommunityOutput> createCommunity(
      CreateCommunityInput input);
}
