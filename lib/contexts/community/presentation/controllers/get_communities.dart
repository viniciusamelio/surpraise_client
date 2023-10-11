import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart' hide CommunityRepository;

abstract class GetCommunitiesController
    extends BaseStateController<List<CommunityOutput>> {
  Future<void> getCommunities(String userId);
}

class DefaultGetCommunitiesController
    with BaseState<Exception, List<CommunityOutput>>
    implements GetCommunitiesController {
  DefaultGetCommunitiesController({
    required GetCommunitiesByUserQuery getCommunitiesByUserQuery,
  }) : _query = getCommunitiesByUserQuery;

  final GetCommunitiesByUserQuery _query;
  @override
  Future<void> getCommunities(String userId) async {
    state.set(LoadingState());
    final communitiesOrError = await _query(
      GetCommunitiesByUserInput(
        id: userId,
      ),
    );
    communitiesOrError.fold(
      (left) => state.set(ErrorState(left)),
      (right) => state.set(
        SuccessState(
          right.value
              .map(
                (e) => CommunityOutput(
                  id: e.id,
                  ownerId: e.ownerId,
                  description: e.description,
                  title: e.title,
                  image: e.image,
                  role: Role.fromString(
                    e.role.value,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
