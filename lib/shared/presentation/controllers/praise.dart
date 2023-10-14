import '../../../contexts/praise/praise.dart';
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
    required GetUserByTagQuery getUserByTagQuery,
  })  : _usecase = praiseUsecase,
        _userByTagQuery = getUserByTagQuery {
    setDefaultErrorHandling();
  }

  final PraiseUsecase _usecase;
  final GetUserByTagQuery _userByTagQuery;

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
    result.fold(
      (left) => null,
      (right) {
        injected<ApplicationEventBus>().add(const PraiseSentEvent(null));
      },
    );
  }

  @override
  final AtomNotifier<int> activeStep = AtomNotifier(0);

  @override
  Future<void> getUserFromTag(String tag) async {
    userState.set(LoadingState());
    final result = await _userByTagQuery(
      GetUserByTagQueryInput(tag: tag),
    );
    result.fold(
      (left) => userState.set(ErrorState(left)),
      (right) {
        userState.set(
          SuccessState(
            UserDto(
              tag: right.value.tag,
              name: right.value.name,
              email: right.value.email,
              id: right.value.id,
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
