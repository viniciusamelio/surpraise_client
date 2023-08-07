import 'package:surpraise_infra/surpraise_infra.dart';

import '../../../../core/core.dart';

abstract class CommunityRepository {
  AsyncAction<List<FindCommunityOutput>> getCommunities(String userId);
  AsyncAction<GetUserOutput?> getUserByTag(String tag);
  AsyncAction<CreateCommunityOutput> createCommunity(
      CreateCommunityInput input);
}
