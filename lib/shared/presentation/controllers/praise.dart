import '../../../contexts/praise/praise.dart';
import '../../../core/core.dart';
import '../../../core/external_dependencies.dart' hide CommunityRepository;
import '../../dtos/user.dart';
import '../dtos/dtos.dart';

abstract class PraiseController extends BaseStateController<PraiseOutput> {
  AtomNotifier<int> get activeStep;
  AtomNotifier<bool> get privatePraise;
  AtomNotifier<DefaultState<Exception, UserDto>> get userState;
  AtomNotifier<List<UserDto>> get praiseds;

  void selectPraised(UserDto user);
  void unselectPraised(UserDto user);

  AtomNotifier<DefaultState<Exception, List<FindCommunityOutput>>>
      get communitiesState;
  PraiseFormDataDto get formData;

  Future<void> sendPraise(String praiserId);
  Future<void> getUserFromTag(String tag);

  void dispose();
}

class DefaultPraiseController
    with BaseState<Exception, PraiseOutput>
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
      private: privatePraise.value,
      topic: "#${formData.topic!}",
      extraPraisedIds: praiseds.value
          .where((element) => element.id != formData.praisedId)
          .map((e) => e.id)
          .toList(),
    );
    final result = await _usecase(input);
    stateFromEither(result);
    result.fold(
      (left) => null,
      (right) {
        injected<ApplicationEventBus>()
            .add(PraiseSentEvent(privatePraise.value));
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
        final user = UserDto(
          tag: right.value.tag,
          name: right.value.name,
          email: right.value.email,
          id: right.value.id,
        );
        userState.set(
          SuccessState(user),
        );
        selectPraised(user);
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
    privatePraise.set(false);
    activeStep.set(0);
    communitiesState.set(InitialState());
    userState.set(InitialState());
    communitiesState.removeListeners();
    userState.removeListeners();
    state.removeListeners();
    state.set(InitialState());
    formData.praisedTag = null;
    praiseds.set([]);
  }

  @override
  final AtomNotifier<bool> privatePraise = AtomNotifier(false);

  @override
  final AtomNotifier<List<UserDto>> praiseds = AtomNotifier([]);

  @override
  void selectPraised(UserDto user) {
    if (praiseds.value.any((element) => element.id == user.id)) {
      return;
    }
    praiseds.set([
      ...praiseds.value,
      user,
    ]);
  }

  @override
  void unselectPraised(UserDto user) {
    praiseds.set(
      praiseds.value.where((element) => element.id != user.id).toList(),
    );
  }
}
