import 'package:flutter/material.dart';

import '../../../contexts/community/community.dart';
import '../../../contexts/praise/praise.dart';
import '../../../core/core.dart';
import '../../dtos/user.dart';
import '../dtos/dtos.dart';

abstract class PraiseController extends BaseStateController<void> {
  ValueNotifier<int> get activeStep;
  ValueNotifier<DefaultState<Exception, UserDto>> get userState;
  ValueNotifier<DefaultState<Exception, List<FindCommunityOutput>>>
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
    state.value = LoadingState();
    final result = await _praiseRepository.send(
      PraiseInput(
        commmunityId: formData.communityId,
        message: formData.message,
        praisedId: formData.praisedId,
        praiserId: praiserId,
        topic: formData.topic,
      ),
    );
    stateFromEither(result);
  }

  @override
  final ValueNotifier<int> activeStep = ValueNotifier(0);

  @override
  Future<void> getUserFromTag(String tag) async {
    userState.value = LoadingState();
    final result = await _communityRepository.getUserByTag(tag);
    result.fold(
      (left) => userState.value = ErrorState(left),
      (right) {
        if (right == null) {
          userState.value = ErrorState(Exception("User not found"));
          return;
        }
        userState.value = SuccessState(
          UserDto(
            tag: right.tag,
            name: right.name,
            email: right.email,
            id: right.id,
          ),
        );
      },
    );
  }

  @override
  final ValueNotifier<DefaultState<Exception, UserDto>> userState =
      ValueNotifier(InitialState());

  @override
  final ValueNotifier<DefaultState<Exception, List<FindCommunityOutput>>>
      communitiesState = ValueNotifier(InitialState());
}
