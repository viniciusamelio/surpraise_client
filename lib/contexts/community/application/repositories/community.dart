import '../../../../core/core.dart';

abstract class CommunityRepository {
  AsyncAction<CreateCommunityOutput> createCommunity(
    CreateCommunityInput input,
  );
  AsyncAction<CreateCommunityOutput> updateCommunity(
    CreateCommunityInput input,
  );
}
