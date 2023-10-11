import 'package:surpraise_infra/surpraise_infra.dart';

import '../../../../core/core.dart';

abstract class CommunityRepository {
  AsyncAction<List<FindCommunityMemberOutput>> getCommunityMembers(String id);
  AsyncAction<CreateCommunityOutput> createCommunity(
    CreateCommunityInput input,
  );
  AsyncAction<CreateCommunityOutput> updateCommunity(
    CreateCommunityInput input,
  );
}
