import '../../../contexts/community/community.dart';
import '../../../core/core.dart';
import '../../../core/external_dependencies.dart' hide CommunityRepository;
import '../../dtos/user.dart';
import '../dtos/dtos.dart';

abstract class PraiseController extends BaseStateController<void> {
  AtomNotifier<int> get activeStep;
  AtomNotifier<DefaultState<Exception, UserDto>> get userState;
  AtomNotifier<DefaultState<Exception, List<FindCommunityOutput>>>
      get communitiesState;
  PraiseFormDataDto get formData;

  Future<void> sendPraise(String praiserId);
  Future<void> getUserFromTag(String tag);

  void dispose();
}

class DefaultPraiseController
    with BaseState<Exception, void>
    implements PraiseController {
  DefaultPraiseController({
    required PraiseUsecase praiseUsecase,
    required CommunityRepository communityRepository,
  })  : _usecase = praiseUsecase,
        _communityRepository = communityRepository {
    setDefaultErrorHandling();
  }

  final PraiseUsecase _usecase;
  final CommunityRepository _communityRepository;

  @override
  final PraiseFormDataDto formData = PraiseFormDataDto();

  @override
  Future<void> sendPraise(String praiserId) async {
    state.set(LoadingState());
    final input = PraiseInput(
      commmunityId: formData.communityId,
      message: formData.message,
      praisedId: formData.praisedId,
      praiserId: praiserId,
      topic: formData.topic!,
    );
    final result = await _usecase(input);
    stateFromEither(result);
  }

  @override
  final AtomNotifier<int> activeStep = AtomNotifier(0);

  @override
  Future<void> getUserFromTag(String tag) async {
    userState.set(LoadingState());
    final result = await _communityRepository.getUserByTag(tag);
    result.fold(
      (left) => userState.set(ErrorState(left)),
      (right) {
        if (right == null) {
          userState.set(ErrorState(Exception("User not found")));
          return;
        }
        userState.set(
          SuccessState(
            UserDto(
              tag: right.tag,
              name: right.name,
              email: right.email,
              id: right.id,
              password: null,
            ),
          ),
        );
      },
    );
  }

  @override
  final AtomNotifier<DefaultState<Exception, UserDto>> userState =
      AtomNotifier(InitialState());

  @override
  final AtomNotifier<DefaultState<Exception, List<FindCommunityOutput>>>
      communitiesState = AtomNotifier(InitialState());

  @override
  void dispose() {
    activeStep.removeListeners();

    activeStep.set(0);
    communitiesState.set(InitialState());
    userState.set(InitialState());
    communitiesState.removeListeners();
    userState.removeListeners();
    state.set(InitialState());
    formData.praisedTag = null;
  }
}
