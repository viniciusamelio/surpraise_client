import 'package:surpraise_infra/surpraise_infra.dart';

import '../../../../core/core.dart';
import '../../dtos/dtos.dart';

abstract class CommunityRepository {
  AsyncAction<List<CommunityOutput>> getCommunities(String userId);
  AsyncAction<List<FindCommunityMemberOutput>> getCommunityMembers(String id);
  AsyncAction<GetUserOutput?> getUserByTag(String tag);
  AsyncAction<CreateCommunityOutput> createCommunity(
    CreateCommunityInput input,
  );
  AsyncAction<CreateCommunityOutput> updateCommunity(
    CreateCommunityInput input,
  );
  AsyncAction<void> leaveCommunity({
    required String communityId,
    required String memberId,
  });
}
