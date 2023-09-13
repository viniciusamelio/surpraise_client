import 'package:flutter/material.dart';

import '../../../contexts/community/community.dart';
import '../../../contexts/praise/praise.dart';
import '../../../core/core.dart';
import '../../../core/external_dependencies.dart'
    hide PraiseRepository, CommunityRepository;
import '../../dtos/user.dart';
import '../dtos/dtos.dart';

abstract class PraiseController extends BaseStateController<void> {
  ValueNotifier<int> get activeStep;
  AtomNotifier<DefaultState<Exception, UserDto>> get userState;
  AtomNotifier<DefaultState<Exception, List<FindCommunityOutput>>>
      get communitiesState;
  PraiseFormDataDto get formData;

  Future<void> sendPraise(String praiserId);
  Future<void> getUserFromTag(String tag);
}

class DefaultPraiseController
    with BaseState<Exception, void>
    implements PraiseController {
  DefaultPraiseController({
    required PraiseRepository praiseRepository,
    required CommunityRepository communityRepository,
  })  : _praiseRepository = praiseRepository,
        _communityRepository = communityRepository {
    setDefaultErrorHandling();
  }

  final PraiseRepository _praiseRepository;
  final CommunityRepository _communityRepository;

  @override
  final PraiseFormDataDto formData = PraiseFormDataDto();

  @override
  Future<void> sendPraise(String praiserId) async {
    state.set(LoadingState());
    final result = await _praiseRepository.send(
      PraiseInput(
        commmunityId: formData.communityId,
        message: formData.message,
        praisedId: formData.praisedId,
        praiserId: praiserId,
        topic: formData.topic!,
      )..id = DateTime.now().toString(),
    );
    stateFromEither(result);
  }

  @override
  final ValueNotifier<int> activeStep = ValueNotifier(0);

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
}
