import 'dart:async';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/dtos/dtos.dart';
import '../../infra/infra.dart';

abstract interface class PraisesSentController {
  AtomNotifier<DefaultState<Exception, List<PraiseDto>>> get state;

  Future<void> get({
    required String communityId,
    required String userId,
    required String praisedId,
  });

  void addReaction(PraiseReactionDto reaction);
  void removeReaction(PraiseReactionDto reaction);
}

class DefaultPraisesSentController implements PraisesSentController {
  DefaultPraisesSentController({
    required GetPraisesSentByUserQuery getPraisesSentByUserQuery,
  }) : _query = getPraisesSentByUserQuery;
  final GetPraisesSentByUserQuery _query;

  @override
  final AtomNotifier<DefaultState<Exception, List<PraiseDto>>> state =
      AtomNotifier(InitialState());

  @override
  Future<void> get({
    required String communityId,
    required String userId,
    required String praisedId,
  }) async {
    state.set(LoadingState());
    final praisesOrError = await _query.call(
      GetPraisesSentByUserQueryInput(
        userId: userId,
        praised: UserDto(
          tag: "",
          name: "",
          email: "",
          id: praisedId,
        ),
        communityId: communityId,
      ),
    );
    state.set(
      praisesOrError.fold(
        (left) => ErrorState(left),
        (right) => SuccessState(right.value),
      ),
    );
  }

  @override
  void addReaction(PraiseReactionDto input) {
    final data = (state.value as SuccessState<Exception, List<PraiseDto>>).data;

    final index = data.indexWhere((element) => element.id == input.praiseId);

    data[index] = data[index].copyWith(
      reactions: [
        ...data[index].reactions,
        input,
      ],
    );
    state.set(SuccessState(data));
  }

  @override
  void removeReaction(PraiseReactionDto input) {
    final data = (state.value as SuccessState<Exception, List<PraiseDto>>).data;
    final index = data.indexWhere((element) => element.id == input.praiseId);
    data[index].reactions.removeWhere(
          (element) => element.id == input.id,
        );
    state.set(SuccessState(data));
  }
}
