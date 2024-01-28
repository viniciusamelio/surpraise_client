import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart' hide AtomAppState;
import '../../../../shared/dtos/reaction.dart';
import '../../application/events/events.dart';
import '../../feed.dart';

abstract class ReactionController {
  AtomNotifier<DefaultState<Exception, void>> get reactionState;
  Future<void> toggleReaction({required PraiseReactionDto input});
}

class DefaultReactionController implements ReactionController {
  DefaultReactionController({
    required FeedRepository feedRepository,
    required ApplicationEventBus eventBus,
  })  : _feedRepository = feedRepository,
        _eventBus = eventBus;
  final FeedRepository _feedRepository;
  final ApplicationEventBus _eventBus;

  @override
  final AtomNotifier<DefaultState<Exception, void>> reactionState =
      AtomNotifier(InitialState());

  @override
  Future<void> toggleReaction({
    required PraiseReactionDto input,
  }) async {
    reactionState.set(LoadingState());
    final reactionResponseOrError = await _feedRepository.toggleReaction(
      userId: input.userId,
      praiseId: input.praiseId,
      reaction: input.reaction,
      reactionId: input.id,
    );
    reactionState.set(
      reactionResponseOrError.fold(
        (left) => ErrorState(left),
        (right) {
          _handleSuccess(input, right);
          return const SuccessState(null);
        },
      ),
    );
  }

  void _handleSuccess(PraiseReactionDto input, String id) {
    if (input.id != null) {
      _eventBus.add<ReactionRemovedEvent>(
        ReactionRemovedEvent(input),
      );
      return;
    }
    _eventBus.add<ReactionAddedEvent>(
      ReactionAddedEvent(input.copyWith(id: () => id)),
    );
  }
}
