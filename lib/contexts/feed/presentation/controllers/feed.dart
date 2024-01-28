import 'dart:async';

import '../../../../core/external_dependencies.dart';
import '../../dtos/dtos.dart';
import '../../feed.dart';

import '../../../../shared/dtos/dtos.dart';
import '../../../../core/core.dart';

abstract class FeedController extends BaseStateController<List<PraiseDto>> {
  Future<void> getPraises(String userId);
  Future<void> getLatestPraises(String userId);

  AtomNotifier<DefaultState<Exception, List<InviteDto>>> get invitesState;
  Future<void> getInvites(String userId);

  Future<void> listenToInvites(String userId);
  Future<void> listenToPraises(String userId);

  void updateReaction(PraiseReactionDto input);
  void removeReaction(PraiseReactionDto input);

  AtomNotifier<int> get offset;
  AtomNotifier<List<PraiseDto>> get loadedPraises;

  StreamController<void> get newFeedItems;

  int get max;
}

class DefaultFeedController
    with BaseState<Exception, List<PraiseDto>>
    implements FeedController {
  DefaultFeedController({
    required FeedRepository feedRepository,
    required RealtimeQuery realtimeQueryClient,
  })  : _repository = feedRepository,
        _queryClient = realtimeQueryClient;
  final RealtimeQuery _queryClient;
  final FeedRepository _repository;
  @override
  Future<void> getPraises(String userId) async {
    state.set(LoadingState());
    final praisesOrError = await _repository.get(
      userId: userId,
      offset: offset.value,
    );
    stateFromEither(praisesOrError);
    praisesOrError.fold(
      (left) => null,
      (right) => loadedPraises.set(
        loadedPraises.value
          ..addAll(
            right,
          ),
      ),
    );
  }

  @override
  Future<void> getInvites(String userId) async {
    invitesState.set(LoadingState());
    final invitesOrError = await _repository.getInvites(userId: userId);
    invitesState.set(
      invitesOrError.fold(
        (left) => ErrorState(left),
        (right) => SuccessState(right),
      ),
    );
  }

  @override
  final AtomNotifier<DefaultState<Exception, List<InviteDto>>> invitesState =
      AtomNotifier(InitialState());

  @override
  AtomNotifier<int> offset = AtomNotifier(0);

  @override
  AtomNotifier<List<PraiseDto>> loadedPraises = AtomNotifier([]);

  @override
  int get max => 10;

  @override
  Future<void> listenToInvites(String userId) async {
    _queryClient.run(
      primaryKeyName: "id",
      source: invitesCollection,
      where: ListenableField(
        fieldName: "member_id",
        value: userId,
      ),
      callback: () => getInvites(userId),
    );
  }

  @override
  Future<void> listenToPraises(String userId) async {
    _queryClient.run(
      primaryKeyName: "id",
      source: praisesCollection,
      where: ListenableField(
        fieldName: "praised_id",
        value: userId,
      ),
      callback: () {
        if (loadedPraises.value.isEmpty) {
          return;
        }
        loadedPraises.value.clear();
        getPraises(userId);
      },
    );
  }

  @override
  Future<void> getLatestPraises(String userId) async {
    final praisesOrError = await _repository.get(userId: userId);
    praisesOrError.fold(
      (left) => null,
      (right) {
        final firstPraise = loadedPraises.value.first;
        if (right.first.id == loadedPraises.value.first.id) {
          return;
        }
        _sortLatestPraises(right, firstPraise);
        state.set(SuccessState(right));
        newFeedItems.add(null);
      },
    );
  }

  void _sortLatestPraises(List<PraiseDto> right, PraiseDto firstPraise) {
    if (loadedPraises.value.length >= 10) {
      final newPraises =
          right.where((element) => !loadedPraises.value.contains(element));
      loadedPraises.set([...newPraises, ...loadedPraises.value]);
      return;
    }
    loadedPraises.set(right);
  }

  @override
  final StreamController<void> newFeedItems = StreamController.broadcast();

  @override
  void updateReaction(PraiseReactionDto input) {
    final index = loadedPraises.value
        .indexWhere((element) => element.id == input.praiseId);

    loadedPraises.value[index] = loadedPraises.value[index].copyWith(
      reactions: [
        ...loadedPraises.value[index].reactions,
        input,
      ],
    );
    newFeedItems.add(null);
  }

  @override
  void removeReaction(PraiseReactionDto input) {
    final index = loadedPraises.value
        .indexWhere((element) => element.id == input.praiseId);
    loadedPraises.value[index].reactions.removeWhere(
      (element) => element.id == input.id,
    );
    newFeedItems.add(null);
  }
}
